import { Controller } from 'stimulus'

export default class extends Controller {
  connect() {
    this.element.addEventListener('load', () => {
      setTimeout(() => {
        let height =
          this.element.contentDocument.querySelector('[data-maglev-section-id]').clientHeight

        if (height < 200) height = 200

        this.element.style.height = `${height}px`
      }, 500)
    })
  }
}
