<template>
  <div
    class="flex items-center pl-6 pr-2 hover:bg-editor-primary hover:bg-opacity-5 transition-colors duration-200"
  >
    <router-link
      :to="{ name: 'editPage', params: { pageId: page.path } }"
      class="flex items-center text-gray-800 overflow-hidden w-full py-3.5"
      :title="page.title"
    >
      <uikit-page-icon :page="page" class="shrink-0" />
      <span class="ml-4 truncate">{{ page.title }}</span>
      <uikit-icon
        class="ml-4 text-gray-400"
        name="ri-eye-off-line"
        size="1rem"
        v-if="!isVisible"
      />
    </router-link>
    <div class="ml-auto pr-2 relative">
      <page-actions-button :page="page" v-on="$listeners" />
    </div>
  </div>
</template>

<script>
import EditPageModal from '@/components/page/edit.vue'
import PageActionsButton from './actions-button.vue'

export default {
  name: 'PageListItem',
  components: {
    PageActionsButton,
  },
  props: {
    page: { type: Object, required: true },
  },
  computed: {
    isIndexPage() {
      return this.services.page.isIndex(this.page)
    },
    isCurrentPage() {
      return this.currentPage.id === this.page.id
    },
    isVisible() {
      return this.page.visible
    },
  },
  methods: {
    openEditPageModal() {
      this.openModal({
        title: this.$t('page.edit.title'),
        component: EditPageModal,
        closeOnClick: false,
        props: {
          page: this.page,
          insideModal: true,
          modalClass: 'w-120 h-144',
        },
        listeners: {
          'on-update': (editedPage) => this.onUpdate(editedPage),
        },
      })
    },
    onUpdate(editedPage) {
      this.closeDropdown()
      if (this.isCurrentPage) this.setCurrentPageSettings(editedPage)
      this.$emit('on-update')
    },
    clonePage() {
      this.services.page.clone(this.page.id).then(() => this.$emit('on-clone'))
    },
    showPage() {
      this.services.page
        .setVisible(this.page.id, true)
        .then(() => this.$emit('on-update'))
    },
    hidePage() {
      this.services.page
        .setVisible(this.page.id, false)
        .then(() => this.$emit('on-update'))
    },
    deletePage() {
      this.closeDropdown()
      this.services.page.destroy(this.page.id).then(() => {
        this.$emit('on-delete')
        if (this.isCurrentPage)
          this.$router.push({ name: 'editPage', params: { pageId: 'index' } })
      })
    },
    closeDropdown() {
      if (!this.$refs.deleteDropdown) return
      this.$refs.deleteDropdown.close()
    },
  },
}
</script>
