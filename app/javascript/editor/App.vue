<template>
  <div>
    <router-view />
    <modal-root />
  </div>
</template>

<script>
export default {
  name: 'App',
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
    currentSectionList(newList) {
      // NOTE: let the editor know that she/he has to add a new section if the page is empty
      if (newList.length === 0 && this.$route.name !== 'addSection')
        this.$router.push({ name: 'addSection' })
    },
  },
}
</script>
