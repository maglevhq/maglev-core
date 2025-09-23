import { Controller } from "@hotwired/stimulus"
import { isSamePath } from"maglev-controllers/utils"

export default class extends Controller { 
  static targets = ["iframe"]
  static values = {
    sectionPath: String,
    sectionBlockPath: String
  }
  
  // called when the iframe DOM is loaded
  sendConfig(event) {
    const { primaryColor, stickySectionIds } = event.params
    this.postMessage('config', {
      primaryColor,
      stickySectionIds,
    })
  }

  // called by the iframe when the user clicks on a setting of a section or a section block
  editSection(event) {
    console.log('[PreviewNotificationCenter][editSection]', event.detail)
    const { sectionId, sectionBlockId, settingId } = event.detail
    const pathTemplate = sectionBlockId ? this.sectionBlockPathValue : this.sectionPathValue
    const path = `${pathTemplate}#${settingId}`.replace(':section_id', sectionId).replace(':section_block_id', sectionBlockId)
    
    if (isSamePath(path)) {
      window.location.hash = settingId
    } else {
      Turbo.visit(path)
    }
  }
  
  // === SECTIONS ===

  addSection(event) {
    console.log('addSection', event.detail.fetchResponse.response.headers.get('X-Section-Id'), event.detail.fetchResponse.response.headers.get('X-Section-Position'))
    const sectionId = event.detail.fetchResponse.response.headers.get('X-Section-Id')
    const position = event.detail.fetchResponse.response.headers.get('X-Section-Position')
    this.postMessage('section:add', { sectionId, insertAt: parseInt(position) })
  }

  deleteSection(event) {
    console.log('deleteSection', event.params)
    const { sectionId } = event.params
    this.postMessage('section:remove', { sectionId  })
  }

  moveSection(event) {
    console.log('moveSection 💨💨💨', event.detail)
    const { oldIndex, newIndex } = event.detail
    this.postMessage('section:move', { oldIndex, newIndex })
  }

  updateSection(event) {
    console.log('updateSection 🧼🧼🧼', event.detail)
    const { sectionId  } = event.detail
    this.postMessage('section:update', { sectionId })
  }

  checkSectionLockVersion(event) {
    console.log('checkSectionLockVersion 🕵🏻‍♂️🕵🏻‍♂️🕵🏻‍♂️', event)
    const { sectionId, lockVersion } = event.detail
    this.postMessage('section:checkLockVersion', { sectionId, lockVersion })
  }
  
  // === SECTION BLOCKS ===

  addSectionBlock(event) {
    console.log('addSectionBlock 💨💨💨', event.params)
    const { sectionId } = event.params
    this.postMessage('block:add', { sectionId })
  }

  deleteSectionBlock(event) {
    console.log('deleteSectionBlock 💨💨💨', event.params)
    const { sectionId, sectionBlockId } = event.params
    this.postMessage('block:remove', { sectionId, sectionBlockId })
  }

  moveSectionBlocks(event) {
    console.log('moveSectionBlocks 💨💨💨', event.params)
    const sectionId = event.params.sectionId
    const { oldItemId: sectionBlockId, newItemId: targetSectionBlockId, direction } = event.detail    
    this.postMessage('block:move', { sectionId, sectionBlockId, targetSectionBlockId, direction })
  }

  // === SETTINGS ===

  updateSetting(event) {
    const { sourceId, change } = event.detail
    this.postMessage('setting:update', { sourceId, change })
  }

  // === STYLE ===

  updateStyle(event) {
    const { style } = event.detail
    this.postMessage('style:update', { style })
  }
  
  // === UTILS ===

  postMessage(type, data) {
    this.iframeTarget.contentWindow.postMessage({ type: `maglev:${type}`, ...(data || {}) }, '*')
  }
}