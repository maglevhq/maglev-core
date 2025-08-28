import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { primaryColor: String }
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
    // TODO: modify the preview iframe viewport
  }

  startLoading() {
    this.element.classList.remove('is-loaded')
  }

  detectUrlChange() {
    const currentPath = new URL(this.iframeTarget.src).pathname
    const newPath = document.querySelector('meta[name=page-preview-url]').content

    if (currentPath !== newPath) this.iframeTarget.src = newPath
  }

  iframeLoaded() {
    this.postMessage('config', {
      primaryColor: this.primaryColorValue,
      stickySectionIds: [], // TODO: get the sticky section ids from the page
    })
  }

  clientReady() {
    this.element.classList.add('is-loaded')
  }

  postMessage(type, data) {
    this.iframeTarget.contentWindow.postMessage({ type, ...(data || {}) }, '*')
  }
}