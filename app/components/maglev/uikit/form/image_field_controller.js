import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [
    'hiddenIdInput', 
    'hiddenUrlInput', 
    'hiddenFilenameInput',
    'hiddenWidthInput', 
    'hiddenHeightInput', 
    'hiddenByteSizeInput',
    'hiddenAltTextInput',
    'image'
  ]
  static values = {
    searchPath: String,
    sourceId: String,
    extraFields: Boolean
  }

  focus() {
    this.openPicker()
  }

  openPicker() {
    const frame = document.querySelector('turbo-frame[id="modal"]')
    frame.src = this.searchPathValue
  }

  onImageSelected(event) {
    const { image } = event.detail

    for (const [key, target] of Object.entries(this.hiddenInputMaps())) {
      target.value = image[key]
    }      
    
    this.imageTarget.classList.remove('hidden')
    this.imageTarget.src = image.url
    this.element.classList.remove('none')

    this.dispatch('change', { detail: { value: image }})
  }

  onChangeAltText(event) {
    const value = { alt_text: event.target.value }
    for (const [key, target] of Object.entries(this.hiddenInputMaps())) {
      value[key] = target.value
    }  
    this.dispatch('change', { detail: { value }})
  }

  clear() {
    Object.values(this.hiddenInputMaps()).forEach(target => target.value = '')

    if (this.hasHiddenAltTextInputTarget) {
      this.hiddenAltTextInputTarget.value = ''
    }

    this.element.classList.add('none')
    const value = this.extraFieldsValue ? {} : null
    this.dispatch('change', { detail: { value }})
  }

  hiddenInputMaps() {
    if (!this.extraFieldsValue) return { url: this.hiddenUrlInputTarget }

    return {
      id: this.hiddenIdInputTarget, 
      url: this.hiddenUrlInputTarget, 
      filename: this.hiddenFilenameInputTarget,
      width: this.hiddenWidthInputTarget, 
      height: this.hiddenHeightInputTarget,
      byte_size: this.hiddenByteSizeInputTarget
    }
  }
}