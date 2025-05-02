import { Controller } from 'stimulus'
import axios from '../utils/axios'

export default class extends Controller {
  static targets = ['source', 'output', 'fileInput']
  static values = { url: String }

  connect() {
    this.sourceTarget.addEventListener('load', () => {
      const html2canvasScript = document.createElement('script')
      html2canvasScript.setAttribute(
        'src',
        'https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.3.3/html2canvas.min.js',
      )
      this.sourceTarget.contentDocument.head.appendChild(html2canvasScript)
    })
  }

  take() {
    const realSource = this.sourceTarget.contentDocument.querySelector(
      '[data-maglev-dropzone]',
    )
    this.sourceTarget.contentWindow
      .html2canvas(realSource, {
        allowTaint: true,
        logging: true,
        useCORS: true,
      })
      .then((canvas) => {
        this.outputTarget.src = canvas.toDataURL() // for debugging purpose
        axios
          .post(this.urlValue, {
            screenshot: { base64_image: canvas.toDataURL() },
          })
          .then(() => {
            alert('Screenshot done!')
          })
          .catch((error) => console.log('ERROR!', error))
      })
  }

  triggerFileInput() {
    this.fileInputTarget.click()
  }

  handleFileUpload(event) {
    const file = event.target.files[0]
    if (!file) return

    const reader = new FileReader()
    reader.onload = () => {
      const base64Image = reader.result
      this.outputTarget.src = base64Image
      
      axios
        .post(this.urlValue, {
          screenshot: { base64_image: base64Image },
        })
        .then(() => {
          alert('Screenshot uploaded!')
        })
        .catch((error) => console.log('ERROR!', error))
    }
    reader.readAsDataURL(file)

    // Clear the input so the same file can be selected again
    event.target.value = ''
  }
}
