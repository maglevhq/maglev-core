import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['hiddenInput', 'image']
  static values = {
    searchPath: String,
    sourceId: String
  }

  focus() {
    this.openPicker()
    this.value = null
  }

  openPicker() {
    const frame = document.querySelector('turbo-frame[id="modal"]')
    frame.src = this.searchPathValue
  }

  onImageSelected(event) {
    console.log('onImageSelected', event.detail)
    this.hiddenInputTarget.value = event.detail.image.image_url
    this.imageTarget.src = event.detail.image.image_url
    this.element.classList.remove('none')
  }

  clear() {
    this.hiddenInputTarget.value = ''
    this.element.classList.add('none')
    this.dispatch(`image-cleared-${this.sourceIdValue}`)
  }
}