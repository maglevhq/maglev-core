<template>
  <submit-button
    type="button"
    class="
      block
      text-white
      w-40
      h-full
      bg-opacity-95
      hover:bg-opacity-100
      transition-colors
      duration-200
    "
    defaultColorClass="bg-editor-primary"
    :labels="$t('headerNav.saveButton')"
    :buttonState="saveState"
    @click="save"
  />
</template>

<script>
import ErrorModalMixin from '@/mixins/error-modal'

export default {
  name: 'SaveButton',
  mixins: [ErrorModalMixin],
  data() {
    return { saveState: 'default' }
  },
  methods: {
    save() {
      this.saveState = 'inProgress'
      this.services.page
        .update(this.currentPage.id, {
          sections: this.currentContent.pageSections,
          lockVersion: this.currentPage.lockVersion,
          ...this.currentPageDefaultAttributes,
        })
        .then(() => {
          this.saveState = 'success'
          Promise.all([
            this.$store.dispatch('fetchPage', this.currentPage.id),
            this.$store.dispatch('fetchSite'),
          ])
        })
        .catch(({ response: { status } }) => {
          console.log('[Maglev] could not save the page', status)
          this.saveState = 'fail'
          if (status === 409) this.openErrorModal('staleRecord')
        })
    },
  },
}
</script>

<style scoped>
.bg-editor-primary {
  background-color: rgba(
    var(--editor-color-primary-non-hex),
    var(--tw-bg-opacity)
  );
}
</style>
