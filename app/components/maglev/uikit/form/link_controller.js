import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['inputItem', 'emptyItem']

  clear() {
    this.element.classList.remove('is-present')
    this.inputItemTarget.remove()
    this.dispatch('change', { detail: { value: {} } })
  }

  textChange(event) {
    this.dispatch('change', { detail: { value: { text: event.target.value } } })
  }

  onLinkSelected(event) {
    this.element.classList.add('is-present')
    this.dispatch('change', { detail: { value: event.detail } })
  }
}