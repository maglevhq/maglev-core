import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['input']
  static values = { settingId: String }

  connect() {
    setTimeout(() => {
      if (window.location.hash) this.focus()
    }, 0)
  }

  onChange(event) {
    console.log('onChange', event)
    const content = event.detail?.content ?? event.target.value
    // we can't use this.dispatchEvent because we want a generic type name for all the inputs
    this.dispatchSettingChange(content)
  }
  
  dispatchSettingChange(value) {
    const newEvent = new CustomEvent("editor-input:settingChange", { detail: {      
      id: this.settingIdValue,
      type: 'text',
      value: value
    } });
    window.dispatchEvent(newEvent)
  }

  focus() {
    const settingId = window.location.hash.replace('#', '')
    if (settingId === this.settingIdValue) {
      if (this.hasInputTarget) {
        this.inputTarget.focus()
      } else {
        this.dispatch('focus')        
      }
    }
  }
}