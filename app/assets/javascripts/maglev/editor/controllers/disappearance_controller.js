import { Controller } from "@hotwired/stimulus"

class DisappearanceController extends Controller {
  static values = { 
    after: Number // in seconds
  }

  connect() {
    if (this.afterValue <= 0) return

    this.timeout = setTimeout(() => {
      this.element.remove()
    }, this.afterValue * 1000)
  }

  disconnect() {
    if (this.timeout) clearTimeout(this.timeout)
  }
}

export default DisappearanceController