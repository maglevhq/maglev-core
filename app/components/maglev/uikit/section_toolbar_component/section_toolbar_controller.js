import { Controller } from '@hotwired/stimulus'
import { enter, leave } from "el-transition"

export default class extends Controller {
  static values = { id: String }
  static targets = ['topLeftCorner', 'topRightCorner', 'bottom']
  
  connect() {
    this.previewScaleRatioValue = 1
  }

  onHover(event) {
    const { sectionId, sectionRect, sectionOffsetTop } = event.detail

    if (sectionId !== this.idValue) {
      // trick to avoid having 2 section toolbars visible at the same time (especially when hovering the + button)
      this.hideEverything()
      return
    }

    this.applyStyle(
      this.calculateStyle(sectionRect, sectionOffsetTop || 0)
    )
    
    this.keepTransitionIntegrity(this.revealEverything.bind(this))    
  }

  onLeave() {
    this.keepTransitionIntegrity(this.hideEverything.bind(this))    
  }

  onScaleRatioUpdated(event) {
    console.log('onScaleRatioUpdated', event.detail.value)
    this.previewScaleRatioValue = event.detail.value
  }

  onWindowScroll(event) {
    this.hideEverything()
  }

  applyStyle(style) {
    Object.entries(style).forEach(
      ([key, value]) => (this.element.style[key] = value),
    )
  }
  
  calculateStyle(sectionRect, minTop) {
    const isSticky = sectionRect.top < minTop
    const top = isSticky ? minTop : sectionRect.top
    const height = isSticky
      ? sectionRect.height - (minTop - sectionRect.top)
      : sectionRect.height
    
    return {
      top: `${top * this.previewScaleRatioValue}px`,
      left: `calc(${this.calculateLeftOffset()}px + (${sectionRect.left}px * ${this.previewScaleRatioValue}))`,
      height: `${height * this.previewScaleRatioValue}px`,
      width: `calc(${sectionRect.width}px * ${this.previewScaleRatioValue})`,
    }
  }

  calculateLeftOffset() {
    // const sidebarWidth =
    //   document.querySelector('.content-area > aside')?.offsetWidth || 0
    // const iframePadding = document.getElementById('iframe-wrapper').getBoundingClientRect().left
    // return iframePadding - sidebarWidth
    return 0
  }

  revealEverything() {
    // console.log(`...reveal ${this.idValue}`)
    this.element.classList.remove('hidden')
    Promise.all([
      enter(this.topLeftCornerTarget),
      enter(this.topRightCornerTarget),
      enter(this.bottomTarget),
    ])
  }

  hideEverything() {
    // console.log(`...hide ${this.idValue}`)
    // do nothing if the section toolbar is already hidden
    if (this.element.classList.contains('hidden') || this.element.classList.contains('is-leaving')) return

    this.element.classList.add('is-leaving')
    Promise.all([
      leave(this.topLeftCornerTarget),
      leave(this.topRightCornerTarget),
      leave(this.bottomTarget),
    ]).then(() => {
      this.element.classList.add('hidden')
      this.element.classList.remove('is-leaving')
    })
  }

  keepTransitionIntegrity(fn) {
    if (this.transitionTimeout) clearTimeout(this.transitionTimeout)
    fn()
    this.transitionTimeout = setTimeout(() => fn(), 200)
  }
}