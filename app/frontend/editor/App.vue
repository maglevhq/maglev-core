<template>
  <div>
    <router-view />
    <uikit-modal-root />
  </div>
</template>

<script>
import ErrorModalMixin from '@/mixins/error-modal'

export default {
  name: 'App',
  mixins: [ErrorModalMixin],
  computed: {
    uiOpenErrorModal() {
      return this.$store.state.ui.openErrorModal
    },
    uiErrorModalType() {
      return this.$store.state.ui.errorModalType
    },
  },
  watch: {
    'currentPage.path'(newPath, oldPath) {
      // NOTE: changing the path of the current page must cause a "reload" of the editor
      if (
        newPath !== oldPath &&
        oldPath !== undefined &&
        newPath != this.$router.currentRoute.params.pageId
      )
        this.$router.push({ name: 'editPage', params: { pageId: newPath } })
    },
    // NOTE: this was an old feature, disabled for now since we've got a warning message for empty pages.
    // currentSectionList(newList) {
    //   // NOTE: let the editor know that she/he has to add a new section if the page is empty
    //   if (newList.length === 0 && this.$route.name !== 'addSection')
    //     this.$router.push({ name: 'addSection' })
    // },
    uiOpenErrorModal(newValue, oldValue) {
      if (newValue && !oldValue) this.openErrorModal(this.uiErrorModalType)
    },
  },
}
</script>
