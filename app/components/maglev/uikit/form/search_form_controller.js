import { Controller } from '@hotwired/stimulus'
import { useDebounce } from 'stimulus-use'

export default class extends Controller {
  static targets = ['input', 'clearButton']
  static debounces = ['handleInput']

  connect() {
    useDebounce(this)
    this._handleInput = this.handleInput.bind(this)
    this.inputTarget.addEventListener('keyup', this._handleInput)
  }

  disconnect() {
    this.inputTarget.removeEventListener('keyup', this._handleInput)
  }

  handleInput(event) {
    if (event.target.value.length > 0) {
      this.clearButtonTarget.classList.remove('invisible')
    } else {
      this.clearButtonTarget.classList.add('invisible')
    }
  }

  clear() {
    this.inputTarget.value = ''
    this.inputTarget.classList.add('invisible')
    this.element.requestSubmit()
  }
}