import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["loading", "iframeWrapper", "iframe"]
  static values = {
    hasSections: Boolean,
  }

  connect() {
    this.setupTransformations()
  }

  disconnect() {
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

  // called when the Maglev client JS lib has been fully loaded on the iframe
  clientReady() {
    this.element.classList.add('is-loaded')
    if (!this.hasSectionsValue) {
      this.element.classList.add('is-empty')
    }
  }

  removeEmptyMessage() {
    this.hasSectionsValue = true
    this.element.classList.remove('is-empty')
  }

  // called when the user navigates to a new page in the editor (another Maglev page OR in a different locale) 
  detectUrlChange() {
    const currentPath = new URL(this.iframeTarget.src).pathname
    const newPath = document.querySelector('meta[name=page-preview-url]').content

    if (currentPath !== newPath) {
      this.iframeTarget.src = newPath
    } else {
      this.clientReady()
    }
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
    const scaleRatio = this.calculateScaleRatio()

    // console.log('calculateTransformations 🍔', this.calculateTransformX(), this.calculateScaleRatio())
    document.body.style.setProperty('--page-preview-transform-x', `${this.calculateTransformX()}px`)
    document.body.style.setProperty('--page-preview-scale-ratio', `${scaleRatio}`)
    
    if (this.expandedPageLayout() && scaleRatio === 1) {
      document.body.style.setProperty('--page-preview-width', `${this.previewMaxWidth()}px`)
    } else {
      document.body.style.setProperty('--page-preview-width', '100%')
    }

    // mainly used for the section toolbars
    this.dispatch('scale-ratio-updated', { detail: {  value: scaleRatio } })
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