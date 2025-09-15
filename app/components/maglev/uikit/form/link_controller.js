import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['inputItem', 'emptyItem']

  clear() {
    console.log('[Link][clear] called')
    this.element.classList.remove('is-present')
    this.inputItemTarget.remove()
    this.dispatch('change', { detail: { value: {} } })
  }

  textChange(event) {
    // this.dispatch('link-text-changed', { detail: { link_text: event.target.value } })
    this.dispatch('change', { detail: { value: { text: event.target.value } } })
  }

  onLinkSelected(event) {
    console.log('[Link][onLinkSelected] 🧁🧁🧁', event.detail)
    this.element.classList.add('is-present')
    // this.dispatch('link-selected', { detail: event.detail })
    this.dispatch('change', { detail: { value: event.detail } })
  }
}