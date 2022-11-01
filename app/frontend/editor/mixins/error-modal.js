import StaleRecord from '@/components/errors/stale-record.vue'

export default {
  methods: {
    openErrorModal(errorType) {
      let ModalComponent = null

      switch (errorType) {
        case 'staleRecord':
          ModalComponent = StaleRecord
          break
        default:
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
