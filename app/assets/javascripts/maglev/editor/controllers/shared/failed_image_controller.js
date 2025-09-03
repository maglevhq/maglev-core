import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this._handleError = this.handleError.bind(this)
    this.element.addEventListener('error', this._handleError)
  }

  disconnect() {
    this.element.removeEventListener('error', this._handleError);
  }

  handleError() {
    this.element.classList.add('hidden')
  }
}