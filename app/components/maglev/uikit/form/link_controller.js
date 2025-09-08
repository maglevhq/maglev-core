import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['inputItem', 'emptyItem']

  // focus() {
  //   // this.inputTarget.focus()
  // }

  clear(event) {
    console.log('clear')
    this.inputItemTarget.classList.add('hidden')
    this.emptyItemTarget.classList.remove('hidden')
    this.dispatch(`link-cleared-${this.sourceIdValue}`)
  }

  onLinkSelected(event) {
    console.log('onLinkSelected', event.detail)
    // this.inputItemTarget.classList.remove('hidden')
    // this.emptyItemTarget.classList.add('hidden')
  }
}