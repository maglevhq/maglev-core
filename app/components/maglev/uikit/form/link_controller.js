import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['inputItem', 'emptyItem']

  clear() {
    console.log('[Link] clear')
    this.element.classList.remove('is-present')
    this.inputItemTarget.remove()
    this.dispatch('link-cleared')
  }

  onLinkSelected(event) {
    console.log('[Link]onLinkSelected 🧁🧁🧁', event.detail)
    this.element.classList.add('is-present')
    this.dispatch('link-selected', { detail: event.detail })
  }
}