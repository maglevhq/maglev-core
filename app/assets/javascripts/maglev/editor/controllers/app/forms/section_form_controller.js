import { Controller } from '@hotwired/stimulus'
import { useDebounce } from 'stimulus-use'
import { log } from 'maglev-controllers/utils'

export default class extends Controller {
  static targets = ['lockVersion']
  static values = { sectionId: String, sectionBlockId: String, sectionLockVersion: String }

  static debounces = ['afterSettingUpdate']

  connect() {
    useDebounce(this)
    
    this.sourceId = this.sectionBlockIdValue !== '' ?  this.sectionBlockIdValue : this.sectionIdValue
    
    requestAnimationFrame(() => {
      this.dispatch('connected', { bubbles: true, detail: { 
        sectionId: this.sectionIdValue, 
          sectionBlockId: this.sectionBlockIdValue, 
          lockVersion: this.sectionLockVersionValue } 
        })
    })

    // we need to keep track of the submitting state to avoid multiple requests being sent with a wrong lock version
    this.submitting = false
    this.element.addEventListener("turbo:submit-start", () => this.submitting = true)    
    this.element.addEventListener('turbo:submit-end', (event) => {
      if (!event.detail.success) this.submitting = false
    })
  }

  onSettingChange(event) {
    log('[SectionForm::onSettingChange]', this.sourceId , event.detail)
    const { detail: { settingType, settingId, value } } = event
    this.dispatch('updateSetting', { detail: {
        sourceId: this.sourceId,
        change: { settingType, settingId, value }
      }
    })
  }

  onPersist(event) {
    log('[SectionForm::onPersist]', event.detail, typeof event.detail)
    this.lockVersionTarget.value = event.detail.lockVersion

    // we are done submitting, so we can reset the submitting flag
    this.submitting = false
  }

  afterSettingUpdate(event) {    
    // if the request is still running (flight), we need to debounce the call
    // to avoid multiple requests being sent with a wrong lock version
    if (this.submitting) {
      this.afterSettingUpdate(event)
      return
    }

    log('[SectionForm::afterSettingUpdate] 🙌🙌', event.detail)

    // we couldn't update the content just by modifying the DOM, so we have to refresh the whole section.
    // The right time to do this is when the request is finished, so we listen for the turbo:submit-end event.
    if (!event.detail.updated) {
      this.element.addEventListener('turbo:submit-end', () => {
        this.dispatch('updateSection', { detail: { sectionId: this.sectionIdValue } })
      }, { once: true })
    }
    
    this.element.requestSubmit()
  }
}