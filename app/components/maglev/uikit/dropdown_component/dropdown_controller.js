import { Controller } from '@hotwired/stimulus'
import { computePosition, flip, shift, autoUpdate } from '@floating-ui/dom'
import { useTransition, useClickOutside } from 'stimulus-use'

export default class extends Controller {
  static targets = ['button', 'content'];

  connect() {
    const button = this.buttonTarget
    const content = this.contentTarget

    this.cleanup = autoUpdate(button, content, () => computePosition(button, content, { 
      placement: 'bottom-start',
      middleware: [flip(), shift()],
    }).then(({x, y}) => {
      Object.assign(content.style, {
        left: `${x}px`,
        top: `${y}px`,
      });
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
    this.cleanup()
  }

  clickOutside(event) {
    this.leave();
  }

  toggle(event) {
    event.preventDefault() && event.stopPropagation()
    this.toggleTransition()
  }
}