import { Controller } from '@hotwired/stimulus'
import { isSamePath } from"maglev-controllers/utils"

export default class extends Controller {
  connect() {
    this._onClick = this.onClick.bind(this)
    this.element.addEventListener("click", this._onClick)
  }

  disconnect() {
    this.element.removeEventListener("click", this._onClick)
  }

  onClick(event) {
    if (isSamePath(event.currentTarget.href)) {
      event.preventDefault();
      event.stopImmediatePropagation();
    }
  }
}