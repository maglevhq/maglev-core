import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['tab', 'tabContent', 'hiddenInput']
  static values = {
    activeClass: String,
    inactiveClass: String
  }

  connect() {
    this.activeClasses = this.activeClassValue.replace(/\s+|\s+/g, ' ').trim().split(' ')
    this.inactiveClasses = this.inactiveClassValue.replace(/\s+|\s+/g, ' ').trim().split(' ')
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
    activeTab.classList.add(...this.inactiveClasses)
  }

  updateTabContent(activeTabContent) {
    this.tabContentTargets.forEach(content => {
      content.classList.add('hidden')
    })

    activeTabContent.classList.remove('hidden')
  }
}