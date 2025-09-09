import { Controller } from '@hotwired/stimulus'
import { useDebounce } from 'stimulus-use'

export default class extends Controller {
  static targets = ["input", "hiddenInput", "list", "option", "spinner"]
  static values = { url: String, turboFrameName: String }
  static debounces = ['remoteFilter']

  connect() {
    this.selectedIndex = -1
    this.highlightedIndex = -1
    this.selectedLabel = null

    this.selectItemAtStartup()

    useDebounce(this)
  }  

  disconnect() {
    if (this.mouseoverBlockedId) clearTimeout(this.mouseoverBlockedId)
    this.teardownObserver()
  }  

  optionTargetConnected(option) {
    this.getObserver().observe(option)
  }

  optionTargetDisconnected(option) {
    this.getObserver().unobserve(option)
  }

  observeOptions(entries, _observer) {
    entries.forEach((entry) => {
      entry.target.selectField = { 
        scrollTop: entry.boundingClientRect.height - entry.intersectionRect.height 
      }      
    })
  }

  choose(event) {
    const index = parseInt(event.currentTarget.dataset.index)
    
    this.selectItem(index)
  }

  focusout(event) {
    if (this.listTarget.contains(event.relatedTarget)) return

    if (this.selectedIndex === -1 && this.inputTarget.value.length === 0) 
      this.reset()
    else if (this.selectedIndex !== -1) {
      this.inputTarget.value = this.getLabel(this.selectedIndex)
    } else {
      this.inputTarget.value = this.selectedLabel
    }   
  }

  filter(event) {
    if (event.key === 'ArrowDown' || event.key === 'ArrowUp' || event.key === 'Enter' || event.key === 'Escape') return

    const query = this.inputTarget.value

    if (query.length === 0) {      
      this.reset()
      return
    }

    if (this.urlValue)
      this.remoteFilter()
    else
      this.localFilter(query)
  }

  localFilter(query) {
    let atLeastOneVisible = false

    this.optionTargets.forEach((option) => {
      const label = option.dataset.label.trim()
      if (label.toLowerCase().includes(query.toLowerCase())) {
        option.classList.remove('hidden')
        atLeastOneVisible = true
      } else
        option.classList.add('hidden')
    })

    if (atLeastOneVisible) {
      this.highlightFirstItem()
      this.open()
    } else {
      this.close()
    }
  }

  remoteFilter() {
    this.spinnerTarget.classList.remove('hidden')

    // clean the state for the next list of results
    this.highlightedIndex = -1
    this.selectedIndex = -1    
    
    fetch(this.buildURL(), { headers: { Accept: "text/vnd.turbo-stream.html" } })
    .then(response => {
      const numberOfOptions = parseInt(response.headers.get('X-Select-Options-Size') ?? '0')
      if (numberOfOptions > 0) 
        this.open() 
      else 
        this.close()
      return response
    })
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))
    .then(() => this.spinnerTarget.classList.add('hidden'))
  }

  mouseover(event) {
    event.stopPropagation() & event.preventDefault()

    if (this.mouseoverBlocked) return

    const option = event.currentTarget
    const index = parseInt(option.dataset.index)

    this.highlightItem(index)
  }   

  handleKeydown(event) {
    if (event.key === 'ArrowDown') {
      this.handleArrowDownKeydown(event)
    } else if (event.key === 'ArrowUp') {
      this.handleArrowUpKeydown(event)      
    } else if (event.key === 'Enter') {
      this.handleEnterKeydown(event)
    } else if (event.key === 'Escape' || event.key === 'Tab') {
      this.close()
    }
  }

  handleArrowUpKeydown(event) {
    event.preventDefault() & event.stopPropagation()

    if (!this.hasOptions()) return

    if (this.isOpen())
      this.highlightPreviousItem()
    else 
      this.open()
  }

  handleArrowDownKeydown(event) {
    event.preventDefault() & event.stopPropagation()

    if (!this.hasOptions()) return

    if (this.isOpen())
      this.highlightNextItem()
    else if (this.selectedIndex !== -1) {
      this.highlightItem(this.selectedIndex)
      this.open()
    } else {
      this.highlightFirstItem()
      this.open()
    }
  }

  handleEnterKeydown(event) {
    if (!this.isOpen()) return

    event.preventDefault() & event.stopPropagation()

    this.selectCurrentItem()
    this.focus()

    // only keep the selected item highlighted 
    if (this.urlValue) {
      this.optionTargets.forEach((option) => {
        if (option.dataset.id !== this.hiddenInputTarget.value)
          option.classList.add('hidden')
      })
    }
  }

  isOpen() {
    return !this.listTarget.classList.contains("hidden")
  }

  open() {
    this.dispatch('showResults')
    this.listTarget.classList.remove("hidden")
  }

  close() {
    this.dispatch('hideResults')
    this.listTarget.classList.add("hidden")
  }

  focus() {
    this.inputTarget.focus()
    this.inputTarget.setSelectionRange(-1, -1)
  }

  toggle() {
    this.focus()
    this.dispatch('toggleResults')
    this.listTarget.classList.toggle("hidden")
  } 

  highlightFirstItem() {
    const index = this.findFirstVisibleItem()
    if (index === null) return
    this.highlightItem(index)
  }

  highlightNextItem() {
    if (this.highlightedIndex >= this.optionTargets.length - 1) return
    const nextIndex = this.findNextVisibleItem(this.highlightedIndex)
    if (nextIndex === null) return
    this.highlightItem(nextIndex, 'down')
  }

  highlightPreviousItem() {
    if (this.highlightedIndex <= 0) return
    const previousIndex = this.findPreviousVisibleItem(this.highlightedIndex)
    if (previousIndex === null) return
    this.highlightItem(previousIndex, 'up')
  }

  highlightItem(index, direction) {
    this.unlighlightCurrentItem()

    const option = this.optionTargets[index]
    option.dataset.focus = true

    if (direction && option.selectField) {
      const scrollTop = option.selectField.scrollTop * (direction === 'up' ? -1 : 1)

      this.blockMouseover()

      this.listTarget.scrollTop += scrollTop      
    }

    this.highlightedIndex = index
  }

  unlighlightCurrentItem() {
    if (this.highlightedIndex === -1) return
   
    const option = this.optionTargets[this.highlightedIndex]
    delete option.dataset.focus
  }

  selectCurrentItem() {
    this.selectItem(this.highlightedIndex)
  }

  selectItem(index) {
    if (index === -1) return

    this.unselectItem(this.selectedIndex)

    const option = this.optionTargets[index]
    option.dataset.selected = true

    this.inputTarget.value = this.getLabel(index)    
    this.hiddenInputTarget.value = option.dataset.id    
    
    this.close()

    this.selectedLabel = this.getLabel(index)
    this.selectedIndex = index

    this.dispatch('change', { detail: { value: this.inputTarget.value } })
  }

  selectItemAtStartup() {
    const selectedId = this.hiddenInputTarget.value
    if (selectedId) {
      const index = this.optionTargets.findIndex((option) => option.dataset.id === selectedId)
      this.selectedLabel = this.inputTarget.value
      this.selectItem(index)
    }
  }

  unselectItem(index) {
    if (index === -1) return
    const option = this.optionTargets[index]
    delete option.dataset.selected
  }

  findFirstVisibleItem() {
    for (let i = 0; i < this.optionTargets.length; i++) {
      if (!this.optionTargets[i].classList.contains('hidden')) return i
    }
    return null
  }

  findNextVisibleItem(index) {
    for (let i = index + 1; i < this.optionTargets.length; i++) {
      if (!this.optionTargets[i].classList.contains('hidden')) return i
    }
    return null
  }

  findPreviousVisibleItem(index) {
    for (let i = index - 1; i >= 0; i--) {
      if (!this.optionTargets[i].classList.contains('hidden')) return i
    }
    return null
  }

  getLabel(index) {
    return this.optionTargets[index].dataset.label.trim()
  }

  hasOptions() {
    return this.optionTargets.length > 0
  }

  reset() {
    this.inputTarget.value = ''
    this.hiddenInputTarget.value = ''
    this.unselectItem(this.selectedIndex)
    
    this.optionTargets.forEach(option => option.classList.add('hidden'))
    this.close()
    
    this.selectedIndex = -1
    this.selectedLabel = null
  }

  buildURL() {
    const params = { query: this.inputTarget.value, turbo_frame: this.turboFrameNameValue }
    const search = new URLSearchParams(params).toString()
    return `${this.urlValue}?${search}`
  }

  blockMouseover() {
    this.mouseoverBlocked = true
    if (this.mouseoverBlockedId) clearTimeout(this.mouseoverBlockedId)
    this.mouseoverBlockedId = setTimeout(() => this.mouseoverBlocked = false, 200)
  }

  getObserver() {
    if (this.observer) return this.observer
    this.observer = new IntersectionObserver(this.observeOptions, {
      root: this.listTarget,
      rootMargin: '0px',
      threshold: [0, 0.25, 0.5, 0.75, 1]
    });
    return this.observer
  }

  teardownObserver() {
    if (this.observer) {
      this.observer.disconnect()
      this.observer = null
    }
  }
}
