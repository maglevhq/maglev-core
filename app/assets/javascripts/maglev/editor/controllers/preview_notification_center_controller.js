import { Controller } from "@hotwired/stimulus"

export default class extends Controller { 

  static targets = ["iframe"]
  
  // called when the iframe DOM is loaded
  sendConfig(event) {
    const { primaryColor, stickySectionIds } = event.params
    this.postMessage('config', {
      primaryColor,
      stickySectionIds, // TODO: get the sticky section ids from the page, use a JSON value
    })
  }
  
  // === SECTIONS ===

  deleteSection(event) {
    const { sectionId } = event.params
    this.postMessage('section:remove', { sectionId  })
  }
  
  // === UTILS ===

  postMessage(type, data) {
    this.iframeTarget.contentWindow.postMessage({ type: `maglev:${type}`, ...(data || {}) }, '*')
  }
}