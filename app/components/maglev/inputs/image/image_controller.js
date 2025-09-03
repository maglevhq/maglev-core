import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['id', 'width', 'height', 'byteSize']
  static values = { settingId: String }
  
  connect() {
    console.log('ImageController connected')
  }

  onImageSelected(event) {
    console.log('[ImageController]onImageSelected', event.detail)
    this.value = event.detail.image

    this.idTarget.value = event.detail.image.id
    this.widthTarget.value = event.detail.image.width
    this.heightTarget.value = event.detail.image.height
    this.byteSizeTarget.value = event.detail.image.byte_size

    this.bubbleChange()
  }

  onImageCleared(event) {
    console.log('[ImageController] onImageCleared', event.detail)
    this.idTarget.value = ''
    this.widthTarget.value = ''
    this.heightTarget.value = ''
    this.byteSizeTarget.value = ''
    this.value = null

    this.bubbleChange()
  }

  altTextChange(event) {
    console.log('[ImageController] altTextChange', this.settingIdValue, event.target.value)
    
    // Update the alt_text in the current value
    this.value = { alt_text: event.target.value }
    
    this.bubbleChange()
  }

  bubbleChange() {
    console.log('[ImageController] bubbleChange', this.settingIdValue, this.value)
    const newEvent = new CustomEvent("editor-input:settingChange", { detail: {      
      id: this.settingIdValue,
      type: 'image',
      value: this.value
    } });
    window.dispatchEvent(newEvent)
  }
}