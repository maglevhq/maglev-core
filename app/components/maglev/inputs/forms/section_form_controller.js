import { Controller } from '@hotwired/stimulus'
import { useDebounce } from 'stimulus-use'

export default class extends Controller {
  static values = { sectionId: String }

  static debounces = ['afterSettingUpdate']

  connect() {
    useDebounce(this)
    console.log('SectionFormController connected')
    // this._onChange = this.onChange.bind(this)
    // this.element.addEventListener('change', this._onChange)
  }

  disconnect() {
    // this.element.removeEventListener('change', this._onChange)
  }

  onSettingChange(event) {
    console.log('onSettingChange', event.detail)
    this.dispatch('updateSetting', { detail: {
        sourceId: this.sectionIdValue,
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