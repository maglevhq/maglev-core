import { Controller } from '@hotwired/stimulus'
import { computePosition, flip, shift, size, autoUpdate } from '@floating-ui/dom'
import { useTransition, useClickOutside } from 'stimulus-use'

export default class extends Controller {
  static targets = ['button', 'content']
  static values = { placement: String }
  
  connect() {
    const button = this.buttonTarget
    const content = this.contentTarget
    const placement = this.directionAwarePlacement(this.placementValue || 'bottom-start')

    this.cleanup = autoUpdate(button, content, () => computePosition(button, content, {
      strategy: 'fixed',
      placement,
      middleware: [
        flip(), 
        shift(),
        size({
          apply({ rects, elements }) {
            Object.assign(elements.floating.style, {
              minWidth: `${rects.reference.width}px`,
            });
          },
        })
      ],
    }).then(({x, y}) => {
      Object.assign(content.style, {
        left: `${x}px`,
        top: `${y}px`,
      })
    }))

    useTransition(this, {
      element: this.contentTarget,
      enterActive: 'transition ease-out duration-100',
      enterFrom: 'transform opacity-0 scale-95',
      enterTo: 'transform opacity-100 scale-100',
      leaveActive: 'transition ease-in duration-75',
      leaveFrom: 'transform opacity-100 scale-100',
      leaveTo: 'transform opacity-0 scale-95',
      transitioned: false,
      preserveOriginalClass: false
    })

    useClickOutside(this)
  }

  disconnect() {
    this.cleanup() // clean up the observer for the floating element

    // fix issue: https://github.com/stimulus-use/stimulus-use/issues/500
    this.enter = null
    this.leave = null
    this.toggleTransition = null
  }

  clickOutside() {
    this.leave()
  }

  toggle(event) {
    event.preventDefault() && event.stopPropagation()
    this.toggleTransition()
  }

  show() {
    this.enter()
  }

  hide() {
    this.leave()
  }

  // Floating UI already flips the -start/-end alignment for RTL, but the physical
  // left/right main side is direction-agnostic. Mirror it so submenus/side popovers
  // open toward the reading direction (e.g. right-start -> left-start in RTL).
  directionAwarePlacement(placement) {
    if (getComputedStyle(this.element).direction !== 'rtl') return placement
    if (placement.startsWith('left')) return placement.replace('left', 'right')
    if (placement.startsWith('right')) return placement.replace('right', 'left')
    return placement
  }
}