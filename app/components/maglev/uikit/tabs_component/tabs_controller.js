import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['tab', 'tabContent', 'hiddenInput']
  static values = {
    activeClass: String,
    inactiveClass: String,
    disableInputs: Boolean
  }

  connect() {
    this.activeClasses = this.activeClassValue.replace(/\s+|\s+/g, ' ').trim().split(' ')
    this.inactiveClasses = this.inactiveClassValue.replace(/\s+|\s+/g, ' ').trim().split(' ')

    this.tabContentTargets.forEach(content => {
      this.changeInputDisabled(content, content.classList.contains('hidden'))
    })
  }

  activateTab(event) {
    const tab = event.currentTarget
    const tabContent = this.tabContentTargets[tab.dataset.tabIndex]

    this.updateTab(tab)
    this.updateTabContent(tabContent)

    this.hiddenInputTarget.value = tab.dataset.tabIndex
  }

  updateTab(activeTab) {
    this.tabTargets.forEach(tab => {
      tab.classList.remove(...this.activeClasses)
      tab.classList.add(...this.inactiveClasses)
    })

    activeTab.classList.remove(...this.inactiveClasses)
    activeTab.classList.add(...this.activeClasses)
  }

  updateTabContent(activeTabContent) {
    this.tabContentTargets.forEach(content => {
      content.classList.add('hidden')
      this.changeInputDisabled(content, true)
    })

    activeTabContent.classList.remove('hidden')
    this.changeInputDisabled(activeTabContent, false)
  }

  changeInputDisabled(tabContent, disabled) {
    if (!this.disableInputsValue) return

    tabContent.querySelectorAll('input, select, textarea').forEach(input => {
      input.disabled = disabled
    })
  }
}