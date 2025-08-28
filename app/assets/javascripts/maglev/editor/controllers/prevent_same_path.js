import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    this._onClick = this.onClick.bind(this)
    this.element.addEventListener("click", this._onClick)
  }

  disconnect() {
    this.element.removeEventListener("click", this._onClick)
  }

  onClick(event) {
    const current = new URL(window.location.href)
    const target  = new URL(event.currentTarget.href, window.location.origin)

    if (current.pathname === target.pathname) {
      event.preventDefault();
      event.stopImmediatePropagation();
    }
  }
}