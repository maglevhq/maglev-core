import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    this._handleChange = this.handleChange.bind(this)
    this.element.addEventListener('change', this._handleChange)
  }

  disconnect() {
    this.element.removeEventListener('change', this._handleChange)
  }

  handleChange() {
    this.element.requestSubmit()
  }
}