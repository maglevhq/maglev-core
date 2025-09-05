import { Controller } from "@hotwired/stimulus"
import { isSamePath } from"maglev-controllers/utils"

export default class extends Controller { 
  static targets = ["iframe"]
  static values = {
    sectionPath: String
  }
  
  // called when the iframe DOM is loaded
  sendConfig(event) {
    const { primaryColor, stickySectionIds } = event.params
    this.postMessage('config', {
      primaryColor,
      stickySectionIds, // TODO: get the sticky section ids from the page, use a JSON value
    })
  }

  // called by the iframe when the user clicks on a setting
  editSection(event) {
    console.log('📨 editSection', event)
    const { sectionId, settingId } = event.detail
    let path = `${this.sectionPathValue}`.replace(':section_id', sectionId)
    path = `${path}#${settingId}`

    if (isSamePath(path)) {
      window.location.hash = settingId
    } else {
      Turbo.visit(path)
    }
  }
  
  // === SECTIONS ===

  addSection(event) {
    console.log('addSection', event, event.detail.fetchResponse.response.headers.get('X-Section-Id'), event.detail.fetchResponse.response.headers.get('X-Section-Position'))
    const sectionId = event.detail.fetchResponse.response.headers.get('X-Section-Id')
    const position = event.detail.fetchResponse.response.headers.get('X-Section-Position')
    this.postMessage('section:add', { sectionId, insertAt: parseInt(position) })
  }

  deleteSection(event) {
    console.log('deleteSection', event)
    const { sectionId } = event.params
    this.postMessage('section:remove', { sectionId  })
  }

  moveSection(event) {
    console.log('moveSection 💨💨💨', event)
    const { oldItemId: sectionId, newItemId: targetSectionId, direction } = event.detail
    this.postMessage('section:move', { sectionId, targetSectionId, direction })
  }

  updateSection(event) {
    console.log('updateSection 🧼🧼🧼', event)
    const { sectionId  } = event.detail
    this.postMessage('section:update', { sectionId })
  }

  // === SETTINGS ===

  updateSetting(event) {
    const { sourceId, change } = event.detail
    this.postMessage('setting:update', { sourceId, change })
  }
  
  // === UTILS ===

  postMessage(type, data) {
    this.iframeTarget.contentWindow.postMessage({ type: `maglev:${type}`, ...(data || {}) }, '*')
  }
}