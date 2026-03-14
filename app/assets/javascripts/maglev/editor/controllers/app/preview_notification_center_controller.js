import { Controller } from "@hotwired/stimulus"
import { isSamePath, log } from "maglev-controllers/utils"

export default class extends Controller { 
  static targets = ["iframe"]
  static values = {
    sectionPath: String,
    sectionBlockPath: String,
    primaryColor: String,
    stickySectionIds: Array,
  }

  connect() {
    this.isClientReady = false
    this.clientReadyCallbacks = []
    this.prefetchedPaths = new Set()
    this.lastConfiguredDocument = null

    // The iframe `load` event can fire before Stimulus wires `load->sendConfig`.
    // If that happens, no config is sent and the client stays undecorated.
    this.sendConfigIfIframeAlreadyLoaded()
  }

  // called when the iframe DOM is loaded
  sendConfig() {
    const { primaryColorValue, stickySectionIdsValue } = this
    const iframeDocument = this.iframeTarget?.contentDocument
    if (!iframeDocument) return

    // Prevent duplicate `config` for the same document (load + fallback path).
    if (this.lastConfiguredDocument === iframeDocument) return

    this.postMessage('config', {
      primaryColor: primaryColorValue,
      stickySectionIds: stickySectionIdsValue,
    })

    // Prevent duplicate `config` for the same document (load + fallback path).
    this.lastConfiguredDocument = iframeDocument
  }

  // called when the Maglev client JS lib has been fully loaded on the iframe
  clientReady(event) {
    this.isClientReady = true
    this.processClientReadyCallbacks()
  }

  // called by the iframe when the user clicks on a setting of a section or a section block
  editSection(event) {
    log('[PreviewNotificationCenter][editSection]', event.detail)
    const { sectionId, sectionBlockId, settingId } = event.detail
    const path = this.buildSettingPath({ sectionId, sectionBlockId, settingId })
    
    if (isSamePath(path)) {
      window.location.hash = settingId
    } else {
      this.visitPath(path)
    }
  }

  editSectionBlock(event) {
    log('[PreviewNotificationCenter][editSectionBlock]', event.detail)
    const { sectionId, sectionBlockId } = event.detail
    const pathTemplate = this.sectionBlockPathValue
    const path = `${pathTemplate}#${sectionBlockId}`.replace(':section_id', sectionId).replace(':section_block_id', sectionBlockId)
    this.visitPath(path)
  }

  prefetchEditSectionOrBlock(event) {
    const { sectionId, sectionBlockId, settingId } = event.detail
    const path = this.buildSettingPath({ sectionId, sectionBlockId, settingId })
    const prefetchPath = this.stripHash(path)

    if (isSamePath(prefetchPath) || this.prefetchedPaths.has(prefetchPath)) return

    this.enqueuePrefetch(prefetchPath)
  }
  
  // === SECTIONS ===

  addSection(event) {
    log('addSection', event.detail.fetchResponse.response.headers.get('X-Section-Id'), event.detail.fetchResponse.response.headers.get('X-Section-Position'))
    const sectionId = event.detail.fetchResponse.response.headers.get('X-Section-Id')
    const position = event.detail.fetchResponse.response.headers.get('X-Section-Position')
    this.postMessage('section:add', { sectionId, insertAt: parseInt(position) })
  }

  deleteSection(event) {
    log('deleteSection', event.params)
    const { sectionId } = event.params
    this.postMessage('section:remove', { sectionId  })
  }

  moveSection(event) {
    log('moveSection 💨💨💨', event.detail)
    const { oldIndex, newIndex } = event.detail
    this.postMessage('section:move', { oldIndex, newIndex })
  }

  updateSection(event) {
    log('updateSection 🧼🧼🧼', event.detail)
    const { sectionId  } = event.detail
    this.postMessage('section:update', { sectionId })
  }

  checkSectionLockVersion(event) {
    log('checkSectionLockVersion 🕵🏻‍♂️🕵🏻‍♂️🕵🏻‍♂️', event)
    const { sectionId, lockVersion } = event.detail
    this.postMessage('section:checkLockVersion', { sectionId, lockVersion })
  }

  pingSection(event) {
    log('pingSection 🏓🏓🏓', event.detail, this.isClientReady)
    const { sectionId } = event.detail
    this.postMessageWhenClientReady('section:ping', { sectionId })
  }
  
  // === SECTION BLOCKS ===

  addSectionBlock(event) {
    log('addSectionBlock ➕➕➕', event.params)
    const { sectionId } = event.params
    this.postMessage('block:add', { sectionId })
  }

  deleteSectionBlock(event) {
    log('deleteSectionBlock 🗑️🗑️🗑️', event.params)
    const { sectionId, sectionBlockId } = event.params
    this.postMessage('block:remove', { sectionId, sectionBlockId })
  }

  moveSectionBlocks(event) {
    log('moveSectionBlocks 💨💨💨', event.params)
    const sectionId = event.params.sectionId
    const { oldItemId: sectionBlockId, newItemId: targetSectionBlockId, direction } = event.detail    
    this.postMessage('block:move', { sectionId, sectionBlockId, targetSectionBlockId, direction })
  }

  pingSectionBlock(event) {
    log('pingSectionBlock 🏓🏓🏓', event.detail)
    const { sectionBlockId } = event.detail
    this.postMessageWhenClientReady('block:ping', { sectionBlockId })
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

  buildSettingPath({ sectionId, sectionBlockId, settingId }) {
    const pathTemplate = sectionBlockId ? this.sectionBlockPathValue : this.sectionPathValue
    return `${pathTemplate}#${settingId}`.replace(':section_id', sectionId).replace(':section_block_id', sectionBlockId)
  }

  stripHash(path) {
    const url = new URL(path, window.location.origin)
    url.hash = ''
    return `${url.pathname}${url.search}`
  }

  enqueuePrefetch(path) {
    if (this.prefetchedPaths.has(path)) return

    this.prefetchedPaths.add(path)

    // Use Turbo's own prefetch pipeline so the visit cache is warmed,
    // which avoids the full loading-bar behavior on subsequent click.
    const link = document.createElement('a')
    link.href = path
    link.dataset.maglevPrefetch = 'true'
    link.dataset.turboPrefetch = 'true'
    link.hidden = true
    document.body.appendChild(link)

    link.dispatchEvent(new MouseEvent('mouseenter', {
      bubbles: true,
      cancelable: true,
      view: window,
    }))

    setTimeout(() => link.remove(), 500)
  }

  visitPath(path) {
    const url = new URL(path, window.location.origin)
    const visitPath = `${url.pathname}${url.search}`
    const hash = url.hash

    if (hash) this.applyHashAfterVisit(hash)
    Turbo.visit(visitPath)
  }

  applyHashAfterVisit(hash) {
    window.addEventListener('turbo:load', () => {
      window.location.hash = hash
    }, { once: true })
  }

  sendConfigIfIframeAlreadyLoaded() {
    const iframeDocument = this.iframeTarget?.contentDocument
    if (!iframeDocument || iframeDocument.readyState !== 'complete') return

    this.sendConfig()
  }

  postMessage(type, data) {
    this.iframeTarget.contentWindow.postMessage({ type: `maglev:${type}`, ...(data || {}) }, '*')
  }

  postMessageWhenClientReady(type, data) {
    if (this.isClientReady) {
      this.postMessage(type, data)
    } else {
      this.clientReadyCallbacks.push({ type, data })
    }
  }

  processClientReadyCallbacks() {
    this.clientReadyCallbacks.forEach(({ type, data }) => this.postMessage(type, data))
    this.clientReadyCallbacks = []
  }
}