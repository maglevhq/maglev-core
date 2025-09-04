import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = { settingId: String }

  connect() {
    console.log('Select controller connected')
  }

  onChange(event) {
    // we can't use this.dispatchEvent because we want a generic type name for all the inputs
    const newEvent = new CustomEvent("editor-input:settingChange", { detail: {      
      id: this.settingIdValue,
      type: 'select',
      value: event.target.value
    } });
    window.dispatchEvent(newEvent)
  }
}