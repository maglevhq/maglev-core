import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static targets = ['revealable']

  enter() {
    enter(this.revealableTarget)
  }

  leave() {
    leave(this.revealableTarget)
  }
}