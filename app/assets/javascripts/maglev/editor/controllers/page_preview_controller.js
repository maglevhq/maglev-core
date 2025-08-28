import { Controller } from "@hotwired/stimulus"
import { useDebounce } from 'stimulus-use'

export default class extends Controller {
  static values = { primaryColor: String }
  static targets = ["loading", "iframe"]

  // static debounces = ['calculateTransformations']

  connect() {
    // useDebounce(this)
    this.setupTransformations()
  }

  disconnect() {
    console.log('PagePreviewController disconnect')
    this.teardownTransformations()
  }

  // --- device management ---
  changeDevice(event) {
    this.element.dataset.device = event.detail.device
    this.calculateTransformations()
  }

  isTabletDevice() {
    return this.element.dataset.device === 'tablet'
  }

  isMobileDevice() {
    return this.element.dataset.device === 'mobile'
  }

  // called when the user is being redirected to a new page in the editor (another Maglev page OR in a different locale) 
  // It displays the splash screen (the loading message). Required for a good UX.
  startLoading() {
    this.element.classList.remove('is-loaded')
  }

  // called when the iframe DOM is loaded
  iframeLoaded() {
    this.postMessage('config', {
      primaryColor: this.primaryColorValue,
      stickySectionIds: [], // TODO: get the sticky section ids from the page, use a JSON value
    })
  }

  // called when the Maglev client JS lib has been fully loaded on the iframe
  clientReady() {
    this.element.classList.add('is-loaded')
  }

  // called when the user navigates to a new page in the editor (another Maglev page OR in a different locale) 
  detectUrlChange() {
    const currentPath = new URL(this.iframeTarget.src).pathname
    const newPath = document.querySelector('meta[name=page-preview-url]').content

    if (currentPath !== newPath) this.iframeTarget.src = newPath
  }

  // Used to communicate with the iframe
  postMessage(type, data) {
    this.iframeTarget.contentWindow.postMessage({ type, ...(data || {}) }, '*')
  }

  // --- Transformation utilities ---

  setupTransformations() {
    this.calculateTransformations = this.calculateTransformations.bind(this)
    this.ro = new ResizeObserver(this.calculateTransformations)
    
    const sidebar = this.appLayoutSidebar
    const pageLayout = document.querySelector('#page-layout')
    if (sidebar) this.ro.observe(this.appLayoutSidebar())
    if (pageLayout) this.ro.observe(pageLayout)
    this.ro.observe(document.documentElement)

    // Recompute on page layout toggles / VT renders
    addEventListener("turbo:render", this.calculateTransformations)
    addEventListener("turbo:before-render", this.calculateTransformations)

    this.calculateTransformations()
  }

  teardownTransformations() {
    this.ro?.disconnect()
    removeEventListener("turbo:render", this.calculateTransformations)
    removeEventListener("turbo:before-render", this.calculateTransformations)
  }

  expandedPageLayout() {
    return document.querySelector('#page-layout[data-expanded]')
  }

  appLayoutSidebar() {
    return document.querySelector('#app-layout-sidebar')
  }

  previewMaxWidth() {
    return window.innerWidth - (this.expandedPageLayout()?.offsetWidth || 0)
  }

  appLayoutSidebarWidth() {
    return this.appLayoutSidebar()?.offsetWidth || 0
  }

  hasExpandedPageLayout() {
    return !!this.expandedPageLayout()
  }

  hasEnoughWidthForTablet() {
    return this.isTabletDevice() && this.previewMaxWidth() > 1024
  }
  
  hasEnoughWidthForMobile() {
    return this.isMobileDevice() && this.previewMaxWidth() > 375
  }

  calculateTransformations() {
    // console.log('calculateTransformations 🍔', this.calculateTransformX(), this.calculateScaleRatio())
    this.element.style.setProperty('--page-preview-transform-x', `${this.calculateTransformX()}px`)
    this.element.style.setProperty('--page-preview-scale-ratio', `${this.calculateScaleRatio()}`)

    if (this.expandedPageLayout() && this.calculateScaleRatio() === 1) {
      this.element.style.setProperty('--page-preview-width', `${this.previewMaxWidth()}px`)
    } else {
      this.element.style.setProperty('--page-preview-width', '100%')
    }
  }

  calculateTransformX() {
    if (!this.hasExpandedPageLayout()) return 0
    return this.expandedPageLayout().offsetWidth - this.appLayoutSidebarWidth()
  }

  calculateScaleRatio() {
    if (!this.mustApplyScale()) return 1
    return this.previewMaxWidth() / (window.innerWidth - this.appLayoutSidebarWidth())
  }

  mustApplyScale() {
    if (!this.hasExpandedPageLayout()) return false

     // case: there is enough width for the tablet viewport, no need to scale down
     if (this.hasEnoughWidthForTablet()) return false

     // case: there is enough width for the mobile viewport, no need to scale down
     if (this.hasEnoughWidthForMobile()) return false

    return true
  }
}