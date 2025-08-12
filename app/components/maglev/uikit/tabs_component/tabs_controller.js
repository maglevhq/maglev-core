import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['tab', 'tabContent']
  static values = {
    activeClass: String,
    inactiveClass: String
  }

  connect() {
    console.log('TabsController connected')
  }

  activateTab(event) {
    event.preventDefault()
    const tab = event.currentTarget
    const tabContent = this.tabContentTargets[tab.dataset.index]
    
    this.updateTab(tab)
    this.updateTabContent(tabContent)
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