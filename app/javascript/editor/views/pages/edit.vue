<template>
  <layout :title="$t('page.edit.currentPage.title')">
    <div class="h-full flex flex-col">
      <edit-page
        :page="currentPage"
        v-if="currentPage"
        @on-update="updateCurrentPage"
      />
    </div>
  </layout>
</template>

<script>
import Layout from '@/layouts/slide-pane'
import EditPage from '@/components/page/edit'

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
