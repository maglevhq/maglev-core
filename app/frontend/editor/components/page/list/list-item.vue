<template>
  <div
    class="flex items-center py-3 pl-6 pr-2 hover:bg-editor-primary hover:bg-opacity-5 transition-colors duration-200"
  >
    <router-link
      :to="{ name: 'editPage', params: { pageId: page.path } }"
      class="flex flex-grow items-center text-gray-800"
    >
      <uikit-page-icon :page="page" />
      <span class="ml-4">{{ page.title }}</span>
      <uikit-icon
        class="ml-4 text-gray-400"
        name="ri-eye-off-line"
        size="1rem"
        v-if="!isVisible"
      />
    </router-link>
    <div class="ml-auto pr-2 relative">
      <uikit-dropdown v-on="$listeners">
        <template v-slot:button>
          <button
            class="px-1 py-1 rounded-full bg-editor-primary bg-opacity-0 hover:text-gray-900 text-gray-600 focus:outline-none hover:bg-opacity-10 transition-colors duration-200"
          >
            <uikit-icon name="ri-more-2-fill" size="1.25rem" />
          </button>
        </template>
        <template v-slot:content>
          <div class="flex flex-col w-48 text-gray-800">
            <button
              class="flex items-center px-4 py-4 hover:bg-gray-100 transition-colors duration-200 focus:outline-none"
              @click.stop="openEditPageModal"
            >
              <uikit-icon name="ri-settings-5-line" />
              <span class="ml-2 whitespace-nowrap">{{
                $t('page.list.item.edit')
              }}</span>
            </button>
            <button
              class="flex items-center px-4 py-4 hover:bg-gray-100 transition-colors duration-200 focus:outline-none"
              @click.stop="clonePage"
            >
              <uikit-icon name="ri-file-copy-line" />
              <span class="ml-2">{{ $t('page.list.item.clone') }}</span>
            </button>
            <button
              class="flex items-center px-4 py-4 hover:bg-gray-100 transition-colors duration-200 focus:outline-none"
              @click.stop="hidePage"
              v-if="isVisible"
            >
              <uikit-icon name="ri-eye-off-line" />
              <span class="ml-2">{{ $t('page.list.item.hide') }}</span>
            </button>
            <button
              class="flex items-center px-4 py-4 hover:bg-gray-100 transition-colors duration-200 focus:outline-none"
              @click.stop="showPage"
              v-if="!isVisible"
            >
              <uikit-icon name="ri-eye-line" />
              <span class="ml-2">{{ $t('page.list.item.show') }}</span>
            </button>
            <uikit-confirmation-button
              @confirm="deletePage"
              ref="deleteDropdown"
              v-if="!isIndexPage"
            >
              <button
                class="flex items-center w-full px-4 py-4 hover:bg-gray-100 transition-colors duration-200 focus:outline-none"
              >
                <uikit-icon name="delete-bin-line" />
                <span class="ml-2">{{ $t('page.list.item.delete') }}</span>
              </button>
            </uikit-confirmation-button>
          </div>
        </template>
      </uikit-dropdown>
    </div>
  </div>
</template>

<script>
import EditPageModal from '@/components/page/edit.vue'

export default {
  name: 'PageListItem',
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
