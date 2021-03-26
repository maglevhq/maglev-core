import { Controller } from 'stimulus'

export default class extends Controller {

  connect() {
    this.element.addEventListener('load', () => {
      const height = this.element.contentDocument.querySelector('body').clientHeight
      this.element.style.height = `${height}px`
    });
    
  }

}