import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this._handleError = this.handleError.bind(this)
    this.element.addEventListener('error', this._handleError)
    
    // Check if image has already errored (e.g., on page refresh)
    if (this.element.complete && this.element.naturalWidth === 0) {
      this.handleError()
    }
  }

  disconnect() {
    this.element.removeEventListener('error', this._handleError);
  }

  handleError() {
    this.element.classList.add('hidden')
  }
}