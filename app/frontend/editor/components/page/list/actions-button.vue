<template>
  <uikit-dropdown v-on="$listeners" popoverClass="tooltip-menu" ref="dropdown">
    <template v-slot:button>
      <uikit-icon-button :iconName="compact ? 'ri-more-fill' : 'ri-more-2-fill'" class="shrink-0" />
    </template>
    <template v-slot:content>
      <div class="flex flex-col w-48 text-gray-800">
        <button
          class="flex items-center px-4 py-4 hover:bg-gray-100 transition-colors duration-200 focus:outline-none"
          @click.stop="editPage"
        >
          <uikit-icon name="ri-settings-5-line" />
          <span class="ml-2 whitespace-nowrap">{{
            $t('page.actions.edit')
          }}</span>
        </button>
        <button
          class="flex items-center px-4 py-4 hover:bg-gray-100 transition-colors duration-200 focus:outline-none"
          @click.stop="clonePage"
        >
          <uikit-icon name="ri-shadow-line" />
          <span class="ml-2">{{ $t('page.actions.clone') }}</span>
        </button>
        <button
          class="flex items-center px-4 py-4 hover:bg-gray-100 transition-colors duration-200 focus:outline-none"
          @click.stop="hidePage"
          v-if="!compact &&isVisible"
        >
          <uikit-icon name="ri-eye-off-line" />
          <span class="ml-2">{{ $t('page.actions.hide') }}</span>
        </button>

        <button
          class="flex items-center px-4 py-4 hover:bg-gray-100 transition-colors duration-200 focus:outline-none"
          @click.stop="showPage"
          v-if="!compact && !isVisible"
        >
          <uikit-icon name="ri-eye-line" />
          <span class="ml-2">{{ $t('page.actions.show') }}</span>
        </button>

        <button
          class="flex items-center px-4 py-4 hover:bg-gray-100 transition-colors duration-200 focus:outline-none"
          :class="{ 'text-green-500': copied }"
          @click.stop="copyUrlToClipboard"
        >
          <uikit-icon name="clipboard-line" v-if="!copied" />
          <uikit-icon name="ri-check-line" v-else />
          <span class="ml-2" v-if="!copied">{{ $t('page.actions.copyUrlToClipboard') }}</span>
          <span class="ml-2" v-else>{{ $t('page.actions.copyUrlToClipboardSuccess') }}</span>
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
            <span class="ml-2">{{ $t('page.actions.delete') }}</span>
          </button>
        </uikit-confirmation-button>
      </div>
    </template>
  </uikit-dropdown>    
</template>

<script>
import { mapGetters } from 'vuex'
import EditPageModal from '@/components/page/edit.vue'

export default {
  name: 'PageActionsButton',
  props: {
    page: { type: Object, required: true },
    compact: { type: Boolean, default: false },
  },
  data() {
    return {
      copied: false,
    }
  },
  computed: {
    ...mapGetters(['currentPageUrl']),    
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
    copyUrlToClipboard() {
      this.copied = true
      navigator.clipboard.writeText(this.currentPageUrl)
      const timeout = setTimeout((() => { this.copied = false }).bind(this), 2000)
      this.$once('hook:beforeDestroy', () => clearTimeout(timeout))
    },
    editPage() {
      this.$refs.dropdown.close()
      if (!this.compact) {
        this.openEditPageModal()
      } else if (this.$route.name !== 'editPageSettings') {        
        this.$router.push({ name: 'editPageSettings' })
      }
    },
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
      this.services.page.clone(this.page.id).then(page => this.$emit('on-clone', page))
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
  }
}
</script>