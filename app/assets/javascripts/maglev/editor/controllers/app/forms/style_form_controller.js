import { Controller } from '@hotwired/stimulus'
import { log } from 'maglev-controllers/utils'

export default class extends Controller {
  static values = { style: Array }

  update(event) {
    log('[StyleForm] update', event.detail, this.styleValue)

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