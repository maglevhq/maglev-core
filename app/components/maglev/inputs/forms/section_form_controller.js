import { Controller } from '@hotwired/stimulus'
import { useDebounce } from 'stimulus-use'

export default class extends Controller {
  static values = { sectionId: String, sectionBlockId: String }

  static debounces = ['afterSettingUpdate']

  connect() {
    useDebounce(this)
    this.sourceId = this.sectionBlockIdValue !== '' ?  this.sectionBlockIdValue : this.sectionIdValue
  }

  onSettingChange(event) {
    console.log('onSettingChange', this.sourceId , event.detail)
    this.dispatch('updateSetting', { detail: {
        sourceId: this.sourceId,
        change: {
          settingType: event.detail.type,
          settingId: event.detail.id,
          value: event.detail.value
        }
      }
    })
  }

  async afterSettingUpdate(event) {
    console.log('afterSettingUpdate 🙌🙌', event.detail)
    await this.element.requestSubmit()
    
    if (!event.detail.updated) {
      // we couldn't update the content just by modifying the DOM, so we have to refresh the whole section
      this.dispatch('updateSection', { detail: { sectionId: this.sectionIdValue } })
    }
  }
}