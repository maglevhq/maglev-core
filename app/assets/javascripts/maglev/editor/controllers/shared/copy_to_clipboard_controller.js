import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['text', 'success']
  static values = {
    source: String,
  }

  copy() {
    this.clean()

    this.textTarget.classList.add('hidden')
    this.successTarget.classList.remove('hidden')

    if (navigator.clipboard) {
      navigator.clipboard.writeText(this.sourceValue)
    } else {
      console.log('Clipboard API not supported or unavailable.')
    }
    
    this.timeout = setTimeout(() => {
      this.successTarget.classList.add('hidden')
      this.textTarget.classList.remove('hidden')
    }, 2000)
  }

  disconnect() {
    this.clean()
  }

  clean() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }
}