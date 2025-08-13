import { Controller } from '@hotwired/stimulus'
import { useDebounce } from 'stimulus-use'

export default class extends Controller {
  static targets = ['input', 'counter']
  static values = {
    threshold: Number,
    thresholdClass: String,
    defaultClass: String
  }
  static debounces = ['updateCounter']

  connect() {
    useDebounce(this)
    this._updateCounter = this.updateCounter.bind(this)
    this.inputTarget.addEventListener('keyup', this._updateCounter)
    this.updateCounter()
  }

  disconnect() {
    this.inputTarget.removeEventListener('keyup', this._updateCounter)
  }

  updateCounter() {
    const isOverThreshold = this.inputTarget.value.length > this.thresholdValue
    this.counterTarget.textContent = `${this.inputTarget.value.length} / ${this.thresholdValue}`
    this.counterTarget.classList.toggle(this.thresholdClassValue, isOverThreshold)
    this.counterTarget.classList.toggle(this.defaultClassValue, !isOverThreshold)
  }
}