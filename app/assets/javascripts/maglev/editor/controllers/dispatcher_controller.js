import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    eventName: String,
    payload: Object
  }

  trigger() {
    this.dispatch(this.eventNameValue, { detail: this.payloadValue })
  }
}