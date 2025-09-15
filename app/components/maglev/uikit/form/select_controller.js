import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  change(event) {
    this.dispatch('change', { detail: { value: event.target.value } })
  }
}