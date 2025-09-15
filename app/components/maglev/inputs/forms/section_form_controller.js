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
    console.log('[SectionForm][onSettingChange]', this.sourceId , event.detail)
    const { detail: { settingType, settingId, value } } = event
    this.dispatch('updateSetting', { detail: {
        sourceId: this.sourceId,
        change: { settingType, settingId, value }
      }
    })
  }

  async afterSettingUpdate(event) {
    console.log('[SectionForm][afterSettingUpdate] 🙌🙌', event.detail)
    await this.element.requestSubmit()
    
    if (!event.detail.updated) {
      // we couldn't update the content just by modifying the DOM, so we have to refresh the whole section
      this.dispatch('updateSection', { detail: { sectionId: this.sectionIdValue } })
    }
  }
}