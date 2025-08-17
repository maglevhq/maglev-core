import { Controller } from '@hotwired/stimulus'
import { FetchRequest } from '@rails/request.js'

export default class extends Controller {
  static targets = ['button', 'fileInput']
  static values = {
    createPath: String,
    refreshPath: String,
    maxsize: Number,
    tooBigErrorMessage: String,
  }

  connect() {
    console.log('UploaderController connected')
  }

  openFileDialog() {    
    this.fileInputTarget.click()
  }

  onFilesSelected() {    
    const allowedFiles = this.allowedFiles()
    if (allowedFiles) {
      this.buttonTarget.disabled = true
      this.uploadFiles(allowedFiles).then(() => {
         this.reloadFrameTag()
      })
      .catch((error) => {        
        console.error(error)
        alert('Network/Server connection error')
      }).finally(() => {
        this.buttonTarget.disabled = false
      })
    } else {
      alert(this.tooBigErrorMessageValue)
    }
  }

  uploadFiles(allowedFiles) {
    return Promise.all(allowedFiles.map((file) => this.uploadSingleFile({ file }, allowedFiles.length)))
  }

  uploadSingleFile(attributes, numberOfAssets) {
    const formData = new FormData()
    formData.append('number_of_assets', numberOfAssets)
    Object.entries(attributes).forEach(([key, value]) =>
      formData.append(`asset[${key}]`, value)
    )

    const request = new FetchRequest('post', this.createPathValue, { body: formData })
    return request.perform()
  }

  allowedFiles() {
    const allowedFiles = []
    const files = this.fileInputTarget.files
    for (var i = 0; i < files.length; i++) {
      const file = files[i]
      if (file && file.size < this.maxsizeValue) {
        allowedFiles.push(file)
      } else return false
    }
    return allowedFiles
  }

  reloadFrameTag() {
    console.log('reloadFrameTag', this.refreshPathValue)
    const frame = document.querySelector(`turbo-frame#modal-dialog`)
    if (frame) {
      frame.src = this.refreshPathValue
      frame.reload()
    }
  }
}