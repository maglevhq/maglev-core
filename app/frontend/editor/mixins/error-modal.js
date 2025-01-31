import StaleRecordModal from '@/components/errors/stale-record.vue'
import ForbiddenModal from '@/components/errors/forbidden.vue'

export default {
  methods: {
    openErrorModal(errorType) {
      let ModalComponent = null

      switch (errorType) {
        case 'staleRecord':
          ModalComponent = StaleRecordModal
          break
        case 'forbidden':
          ModalComponent = ForbiddenModal
          break
        default:
          console.warn("Unknown errorType:", errorType)
          return // unknown error type
      }

      this.openModal({
        title: this.$t(`errorModals.${errorType}.title`),
        component: ModalComponent,
        props: { modalClass: 'w-144' },
      })
    },
  },
}
