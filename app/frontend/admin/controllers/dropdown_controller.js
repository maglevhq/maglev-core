import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['toggleable']

  toggle() {
    this.toggleableTarget.classList.toggle('hidden')
  }
}
