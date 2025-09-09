import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.refreshInput = document.createElement('input')
    this.refreshInput.type = 'hidden'
    this.refreshInput.name = 'refresh'
    this.element.appendChild(this.refreshInput)
  }

  refresh(event) {
    this.refreshInput.value = '1'
    this.element.requestSubmit()
  }
}