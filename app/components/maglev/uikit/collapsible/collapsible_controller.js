import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]

  toggle(event) {
    event.currentTarget.closest('[data-uikit-collapsible-target="item"]').classList.toggle("is-collapsed")
  }
}