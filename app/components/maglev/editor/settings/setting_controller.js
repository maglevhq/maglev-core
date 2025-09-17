import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = { 
    settingId: String, 
    settingType: String,
    coreControllerName: String
  }

  connect() {
    console.log('[Editor::Setting] connect', this.settingIdValue)

    if (window.location.hash) {
      // dirty way to wait for the underlying controller to be connected
      setTimeout(() => this.focus(), 100)
    }
  }

  change(event) {
    console.log('[Editor::Setting] change', event)
    this.dispatch('change', { 
      detail: {         
        settingId: this.settingIdValue,
        settingType: this.settingTypeValue,
        value: event.detail.value
      }
    })
  }

  focus() {
    const settingId = window.location.hash.replace('#', '')
    
    if (settingId !== this.settingIdValue || !this.hasCoreControllerNameValue) return

    const coreController = this.application.getControllerForElementAndIdentifier(
      this.element.querySelector(`[data-controller=${this.coreControllerNameValue}]`),
      this.coreControllerNameValue
    )

    if (coreController) coreController.focus()
  }      
}