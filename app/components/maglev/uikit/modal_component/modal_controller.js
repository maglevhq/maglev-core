import { Controller } from "@hotwired/stimulus"
import { enter, leave } from 'el-transition'

export default class extends Controller {
  static targets = ['dialog', 'backgroundBackdrop']
  static values = { id: String, open: Boolean, focus: Boolean }

  connect() {
    if (this.openValue || window.location.hash === `#${this.idValue}`) this.delayedOpen()
  }

  delayedOpen() {
    setTimeout(() => this.open(), 200)
  }

  openFromUrl(event) {
    if (event.target.location.hash === `#${this.idValue}`) {
      this.open()
    }
  }

  open() {    
    this.element.classList.remove('hidden')

    enter(this.dialogTarget)
    enter(this.backgroundBackdropTarget)

    if (this.focusValue === true) {
      const firstInput = this.element.querySelector('input[type=text], input[type=search], input[type=email]')
      firstInput?.focus()
    }
  }

  close(event) {
    // closing after a form submission? Closing the modal only the request was successful.
    if (event?.detail?.formSubmission !== undefined && event?.detail?.success === false)
      return
    
    leave(this.dialogTarget)
    leave(this.backgroundBackdropTarget)

    // wait for 400ms (max duration of an animation)
    setTimeout(() => this.element.classList.add('hidden'), 400)

    if (this.idValue) history.replaceState(null, null, ' ')
  }
}