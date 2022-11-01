import { Controller } from 'stimulus'

export default class extends Controller {
  connect() {
    this.element.addEventListener('load', () => {
      let height =
        this.element.contentDocument.querySelector('body').clientHeight

      if (height < 200) height = 200

      this.element.style.height = `${height}px`
    })
  }
}
