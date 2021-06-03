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
      // NOTE: changing the path of the current page causes a "reload" of the editor
      if (newPath !== oldPath && oldPath !== undefined && newPath != this.$router.currentRoute.params.pageId) {
        this.$router.push({ name: 'editPage', params: { pageId: newPath } })
      }        
    }
  }
}
</script>
