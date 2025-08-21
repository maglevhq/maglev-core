import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["device"]
  static values = {
    activeClasses: String,
  }

  connect() {
    this.activeClasses = this.activeClassesValue.split(' ')
  }

  toggle(event) {
    this.deviceTargets.forEach((device) => {
      device.classList.remove(...this.activeClasses)
    })
    event.currentTarget.classList.add(...this.activeClasses)

    this.dispatch('change', { detail: { device: event.currentTarget.dataset.device } })
  }
}