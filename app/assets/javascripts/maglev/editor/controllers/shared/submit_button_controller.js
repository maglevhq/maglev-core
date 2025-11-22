import { Controller } from "@hotwired/stimulus"
import { sleep } from"maglev-controllers/utils"

export default class extends Controller {

  initialize() {
    this._start = this.start.bind(this)
    this._end = this.end.bind(this)
    this._cancel = this.cancel.bind(this)    
  }

  connect() {
    this.canceled = false
    this.formElement = this.element.closest('form')
    this.formElement.addEventListener('turbo:submit-start', this._start)
    this.formElement.addEventListener('turbo:submit-end', this._end)
    document.addEventListener("turbo:before-cache", this._cancel)
  }

  disconnect() {
    this.canceled = true
    this.formElement.removeEventListener('turbo:submit-start', this._start)
    this.formElement.removeEventListener('turbo:submit-end', this._end)    
  }

  cancel() {
    this.canceled = true
    this.element.disabled = false
    this.formElement.classList.remove('is-pending', 'is-success', 'is-error')
    this.formElement.classList.add('is-default')    
  }

  start() {
    this.formElement.classList.add('is-pending')
    this.startedAt = Date.now()
  }

  async end(event) {
    // still disabled
    this.element.disabled = true

    // on an UX standpoint, we want to show the pending state for a short time to avoid flickering
    // if the submit (call to the server) took less than 800ms, we wait for 800ms to show the pending state
    if (Date.now() - this.startedAt < 600) await sleep(600)

    if (this.canceled) return

    this.formElement.classList.remove('is-pending')
    this.formElement.classList.add(event.detail.success ? 'is-success' : 'is-error')      
    
    // wait for 2 seconds and then remove the success or error class and add the default class
    await sleep(1400)

    if (this.canceled) return
    
    this.formElement.classList.remove(event.detail.success ? 'is-success' : 'is-error')
    this.formElement.classList.add('is-default')
    this.element.disabled = false
  }
}