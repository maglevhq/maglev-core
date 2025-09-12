import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['input', 'preview', 'preset']

  change(event) {
    const color = event.target.value
    this.element.classList.toggle('is-empty', color === '')
    if (color !== '') this.applyColor(color)
  }

  selectPreset(event) {    
    this.presetTargets.forEach(preset => preset.classList.remove('is-active'))
    event.currentTarget.classList.add('is-active')
    this.element.classList.remove('is-empty')
    this.applyColor(event.params.value)
  }

  applyColor(color) {
    if (!color.startsWith('#')) color = `#${color}`
    this.inputTarget.value = color
    this.previewTarget.style.backgroundColor = color
  }
}