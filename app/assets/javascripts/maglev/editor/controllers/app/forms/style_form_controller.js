import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = { style: Array }

  update(event) {
    console.log('[StyleForm] update', event.detail, this.styleValue)

    const newStyle = this.styleValue
    newStyle.forEach(style => {
      if (style.id === event.detail.settingId) {
        style.value = event.detail.value
      }
    })
    this.styleValue = newStyle

    this.dispatch('onUpdate', { detail: { style: newStyle } })
  }
}