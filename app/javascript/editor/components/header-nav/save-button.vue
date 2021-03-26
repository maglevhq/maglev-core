<template>
  <submit-button 
    type="button"
    class="block text-white w-40 h-full" 
    defaultColorClass="bg-editor-primary"
    :labels="$t('headerNav.saveButton')"    
    :buttonState="saveState"
    @click="save"
  />
</template>

<script>
export default {
  name: 'SaveButton',
  data() {
    return { saveState: 'default' };
  },
  methods: {
    save() {
      this.saveState = 'inProgress'
      this.services.page.update(this.currentPage.id, {
        sections: this.currentContent.pageSections
      })
      .then(() => this.saveState = 'success')
      .catch(err => {
        console.log('[Maglev] could not save the page', err)
        this.saveState = 'fail'
      })
    }
  }
}
</script>

<style scoped>
.bg-editor-primary {
  background-color: rgba(var(--editor-color-primary-non-hex), var(--bg-opacity));
}
</style>
