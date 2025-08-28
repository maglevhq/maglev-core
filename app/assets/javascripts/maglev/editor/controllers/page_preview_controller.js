import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String, primaryColor: String }
  static targets = ["loading", "iframe"]

  connect() {
    console.log('PagePreviewController', this.urlValue)
    this.iframeTarget.addEventListener('load', this.iframeLoaded.bind(this))
  }

  disconnect() {
    console.log('PagePreviewController disconnect')
  }

  changeDevice(event) {
    console.log('changeDevice', event.detail.device)
  }

  iframeLoaded() {
    this.postMessage('config', {
      primaryColor: this.primaryColorValue,
      stickySectionIds: [],
    })
  }

  clientReady(event) {
    console.log('clientReady 🍔')
    this.loadingTarget.classList.add('hidden')
    this.iframeTarget.classList.remove('hidden')
  }

  postMessage(type, data) {
    this.iframeTarget.contentWindow.postMessage({ type, ...(data || {}) }, '*')
  }
}