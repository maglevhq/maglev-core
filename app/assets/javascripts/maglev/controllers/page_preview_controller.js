import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }
  static targets = ["loading", "iframeWrapper"]

  connect() {
    console.log('PagePreviewController', this.urlValue)
    this.createIframe()
  }

  disconnect() {
    console.log('PagePreviewController disconnect')
  }

  changeDevice(event) {
    console.log('changeDevice', event.detail.device)
  }

  createIframe() {
    console.log('createIframe', !!this.element.querySelector('iframe'))
    if (this.element.querySelector('iframe')) return

    console.log('createIframe 🤬🤬🤬🤬')

    const iframe = document.createElement('iframe')
    iframe.src = this.urlValue
    iframe.classList.add('w-full', 'h-full')    
    this.iframeWrapperTarget.appendChild(iframe)
    // this.iframeWrapperTarget.classList.remove('hidden')
    // this.loadingTarget.classList.add('hidden')
  }
}