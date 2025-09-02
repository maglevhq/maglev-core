import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['hiddenInput', 'image']
  static values = {
    searchPath: String
  }

  focus() {
    this.openPicker()
  }

  clear() {
    this.hiddenInputTarget.value = ''
    this.element.classList.add('none')
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
}