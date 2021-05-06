import { Controller } from 'stimulus'
import html2canvas from 'html2canvas'
import axios from '../utils/axios'

export default class extends Controller {
  static targets = ['source', 'output']
  static values = { url: String }

  take() {
    const realSource = this.sourceTarget.contentDocument.querySelector('body')
    html2canvas(realSource).then(canvas => {
      this.outputTarget.src = canvas.toDataURL() // for debugging purpose
      axios.post(this.urlValue, { screenshot: { base64_image: canvas.toDataURL() } }).then(() => {
        alert('Screenshot done!')
      }).catch(error => console.log('ERROR!', error))
    });
  }

}