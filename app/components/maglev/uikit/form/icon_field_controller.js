import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['icon', 'hiddenInput']
  static values = { searchPath: String, icon: String }

  focus() {
    this.openPicker()
  }

  openPicker() {
    const frame = document.querySelector('turbo-frame[id="modal"]')
    frame.src = this.searchPathValue
  }

  onIconSelected(event) {
    const icon = event.detail.icon
    
    this.hiddenInputTarget.value = icon  

    this.iconTarget.classList.remove(this.iconValue)
    this.iconTarget.classList.add(icon)

    this.element.classList.remove('none')

    this.iconValue = icon

    this.dispatch('change', { detail: { value: icon }})
  }

  clear() {
    this.hiddenInputTarget.value = ''
    this.element.classList.add('none')
    this.dispatch('change', { detail: { value: null }})
  }
}