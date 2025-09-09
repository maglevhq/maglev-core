import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    console.log('LinkComponentController connected')
  }
  
  onLinkCleared() {
    console.log('[Section][Link] onLinkCleared')
    this.bubbleChange({})
  }

  onLinkSelected(event) {
    console.log('[Section][Link] onLinkSelected', event.detail)
    this.bubbleChange(event.detail)
  }

  onLinkTextChanged(event) {
    console.log('[Section][Link] onLinkTextChanged', event.detail)
    this.bubbleChange(event.detail)
  }

  bubbleChange(linkValue) {
    const newEvent = new CustomEvent("editor-input:settingChange", { detail: {      
      id: this.settingIdValue,
      type: 'link',
      value: linkValue
    } });
    window.dispatchEvent(newEvent)
  }
}