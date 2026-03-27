import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["loading", "iframeWrapper", "iframe"]
  
  connect() {
    this.setupTransformations()
    this.numberOfSections = null
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
    this.element.classList.remove('is-empty') 
  }

  // force reload the iframe
  reload() {
    this.startLoading()
    if (!this.reloadIframeInPlace()) {
      this.iframeTarget.src = this.iframeTarget.src
    }
  }

  // called when the Maglev client JS lib has been fully loaded on the iframe
  clientReady(event) {
    const { numberOfSections } = event.detail

    this.element.classList.add('is-loaded')
    this.numberOfSections = numberOfSections    
    this.updateEmptyMessageState()
  }

  removeEmptyMessage() {
    this.numberOfSections = (this.numberOfSections ?? 0) + 1
    this.updateEmptyMessageState()
  }

  // called when the user navigates to a new page in the editor (another Maglev page OR in a different locale) 
  detectUrlChange() {
    const meta = document.querySelector('meta[name=page-preview-url]')
    if (!meta?.content) return

    const targetUrl = meta.content
    let currentHref
    let targetHref
    try {
      currentHref = new URL(this.iframeTarget.src, document.baseURI).href
      targetHref = new URL(targetUrl, document.baseURI).href
    } catch {
      return
    }

    if (currentHref !== targetHref) {
      this.startLoading()
      this.assignIframeSrcWithoutHistory(targetUrl)
    } else {
      this.element.classList.add('is-loaded')
      this.updateEmptyMessageState()
    }
  }

  // Assigning iframe.src pushes a joint session-history entry in most browsers, so the first Back
  // pops the iframe instead of the parent Turbo visit. replace/reload avoid that when same-origin.
  assignIframeSrcWithoutHistory(url) {
    try {
      const win = this.iframeTarget.contentWindow
      if (win?.location?.replace) {
        win.location.replace(url)
        return
      }
    } catch {
      // cross-origin iframe document: fall back to src
    }
    this.iframeTarget.src = url
  }

  reloadIframeInPlace() {
    try {
      const win = this.iframeTarget.contentWindow
      if (win?.location?.reload) {
        win.location.reload()
        return true
      }
    } catch {
      // cross-origin: caller will fall back to reassigning src
    }
    return false
  }

  updateEmptyMessageState() {
    if (this.numberOfSections === 0) {
      this.element.classList.add('is-empty')
    } else {
      this.element.classList.remove('is-empty')
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