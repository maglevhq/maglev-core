import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['input']
  static values = { settingId: String }

  connect() {
    if (window.location.hash) this.focus()
  }

  onKeyUp(event) {
    // we can't use this.dispatchEvent because we want a generic type name for all the inputs
    const newEvent = new CustomEvent("editor-input:settingChange", { detail: {      
      id: this.settingIdValue,
      type: 'text',
      value: event.target.value
    } });
    window.dispatchEvent(newEvent)
  }

  focus(event) {
    const settingId = window.location.hash.replace('#', '')
    if (settingId === this.settingIdValue) this.inputTarget.focus()
  }
}