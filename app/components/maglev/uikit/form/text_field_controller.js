import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['input']

  change(event) {
    const text = event.target.value
    this.dispatch('change', { detail: { value: text } })
  }

  focus() {
    const input = this.inputTarget
    const len = input.value.length
    input.focus()
    input.setSelectionRange(len, len)
    input.scrollLeft = input.scrollWidth
  }
}