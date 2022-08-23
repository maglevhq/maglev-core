import { useUIStore } from '@/stores/ui-store'
import i18n from '@/plugins/i18n'

import StaleRecord from '@/components/errors/stale-record.vue'

export default () => {
  const uiStore = useUIStore()
  const { t } = i18n.global

  const openErrorModal = (errorType) => {
    let ModalComponent = null

    switch (errorType) {
      case 'staleRecord':
        ModalComponent = StaleRecord
        break
      default:
        return // unknown error type
    }

    uiStore.openModal({
      title: t(`errorModals.${errorType}.title`),
      component: ModalComponent,
      props: { modalClass: 'w-144' },
    })
  }

  return {
    openErrorModal,
  }
}
