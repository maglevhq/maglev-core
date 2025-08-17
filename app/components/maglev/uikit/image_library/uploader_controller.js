import { Controller } from '@hotwired/stimulus'
import { FetchRequest } from '@rails/request.js'

export default class extends Controller {
  static targets = ['button', 'fileInput']
  static values = {
    createPath: String,
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
      this.uploadFiles(allowedFiles).then(refreshPath => {
         this.reloadFrameTag(refreshPath)
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

  async uploadFiles(allowedFiles) {
    const locations = await Promise.all(allowedFiles.map((file) => this.uploadSingleFile({ file }, allowedFiles.length)))
    return locations.length > 0 ? locations[0] : null
  }

  async uploadSingleFile(attributes, numberOfAssets) {
    const formData = new FormData()
    formData.append('number_of_assets', numberOfAssets)
    Object.entries(attributes).forEach(([key, value]) =>
      formData.append(`asset[${key}]`, value)
    )

    const request = new FetchRequest('post', this.createPathValue, { body: formData })
    const response = await request.perform()

    if (response.ok) {
      return response.headers.get('Location')
    } else {
      console.log('Maglev upload error', response)
      throw new Error('Network/Server connection error')
    }
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

  reloadFrameTag(refreshPath) {
    const frame = document.querySelector(`turbo-frame#modal-dialog`)
    if (frame) {
      frame.src = refreshPath
      frame.reload()
    }
  }
}