import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['id', 'width', 'height', 'byteSize']
  static values = { settingId: String }

  connect() {
    if (window.location.hash) {
      // dirty way to wait for the ImageFieldController to be connected
      setTimeout(() => this.focus(), 100)
    }
  }
  
  onImageSelected(event) {
    this.value = event.detail.image

    this.idTarget.value = event.detail.image.id
    this.widthTarget.value = event.detail.image.width
    this.heightTarget.value = event.detail.image.height
    this.byteSizeTarget.value = event.detail.image.byte_size

    this.bubbleChange()
  }

  onImageCleared() {
    this.value = null

    this.idTarget.value = ''
    this.widthTarget.value = ''
    this.heightTarget.value = ''
    this.byteSizeTarget.value = ''
    
    this.bubbleChange()
  }

  altTextChange(event) {
    // Update the alt_text in the current value
    this.value = { alt_text: event.target.value }
    
    this.bubbleChange()
  }

  bubbleChange() {
    const newEvent = new CustomEvent("editor-input:settingChange", { detail: {      
      id: this.settingIdValue,
      type: 'image',
      value: this.value
    } });
    window.dispatchEvent(newEvent)
  }

  focus() {
    const settingId = window.location.hash.replace('#', '')
    if (settingId === this.settingIdValue) {
      const imageFieldController = this.application.getControllerForElementAndIdentifier(
        this.element.querySelector('[data-controller=uikit-form-image-field]'),
        'uikit-form-image-field'
      )
      if (imageFieldController) imageFieldController.openPicker() 
    }
  }
}