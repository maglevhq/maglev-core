import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['tab', 'tabContent', 'hiddenInput']
  static values = {
    activeClass: String,
    inactiveClass: String
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
      tab.classList.remove(...this.activeClassValue.split(' '))
      tab.classList.add(...this.inactiveClassValue.split(' '))
    })

    activeTab.classList.remove(...this.inactiveClassValue.split(' '))
    activeTab.classList.add(...this.activeClassValue.split(' '))
  }

  updateTabContent(activeTabContent) {
    this.tabContentTargets.forEach(content => {
      content.classList.add('hidden')
    })

    activeTabContent.classList.remove('hidden')
  }
}