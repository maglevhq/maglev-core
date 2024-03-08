<template>
  <layout :title="$t('page.edit.currentPage.title')" :overflowY="false">
    <div class="flex flex-col flex-1 pb-4 overflow-y-hidden">
      <edit-page
        :page="currentPage"
        v-if="currentPage"
        @on-update="updateCurrentPage"
      />
    </div>
  </layout>
</template>

<script>
import Layout from '@/layouts/slide-pane.vue'
import EditPage from '@/components/page/edit.vue'

export default {
  name: 'EditPageView',
  components: { Layout, EditPage },
  methods: {
    updateCurrentPage(updatedPage) {
      this.setCurrentPageSettings(updatedPage)
    },
  },
}
</script>
