<template>
  <nav class="w-16 flex flex-col justify-between">
    <div
      class="flex justify-center h-full w-full animate-pulse"
      v-if="!currentPage"
    >
      <div class="w-6 bg-gray-200 rounded h-48 my-6"></div>
    </div>
    <ol class="divide-y divide-gray-300 px-4" v-else>
      <li>
        <router-link
          :to="{ name: 'listSections' }"
          class="flex justify-center py-5 -ml-4 -mr-4 hover:bg-editor-primary hover:bg-opacity-5 transition-colors duration-200"
          :class="{
            'bg-white': !isSectionListPaneActive,
            'bg-editor-primary bg-opacity-5': isSectionListPaneActive,
          }"
          v-tooltip.right="$t('sidebarNav.managePageSectionsTooltip')"
        >
          <uikit-icon name="ri-stack-line" size="1.5rem" />
        </router-link>
      </li>
      <li v-if="hasStyle">
        <router-link
          :to="{ name: 'editStyle' }"
          class="flex justify-center py-5 -ml-4 -mr-4 hover:bg-editor-primary hover:bg-opacity-5 transition-colors duration-200"
          :class="{
            'bg-white': !isEditStylePaneActive,
            'bg-editor-primary bg-opacity-5': isEditStylePaneActive,
          }"
          v-tooltip.right="$t('sidebarNav.editStyleTooltip')"
        >
          <uikit-icon name="ri-drop-line" size="1.25rem" />
        </router-link>
      </li>
      <li>
        <a
          href="#"
          class="flex justify-center py-5 -ml-4 -mr-4 hover:bg-editor-primary hover:bg-opacity-5 transition-colors duration-200"
          @click.prevent="openImageLibraryModal"
          v-tooltip.right="$t('sidebarNav.openImageLibraryTooltip')"
        >
          <uikit-icon name="image-line" size="1.5rem" />
        </a>
      </li>
      <li v-if="false">
        <router-link
          :to="{ name: 'test', params: { pageId: currentPage.path } }"
          class="flex justify-center py-5 -ml-4 -mr-4 hover:bg-editor-primary hover:bg-opacity-5 transition-colors duration-200"
        >
          T
        </router-link>
      </li>
      <li v-if="false">
        <router-link
          :to="{ name: 'test2', params: { pageId: currentPage.path } }"
          class="flex justify-center py-5 -ml-4 -mr-4 hover:bg-editor-primary hover:bg-opacity-5 transition-colors duration-200"
        >
          T2
        </router-link>
      </li>
      <li></li>
    </ol>

    <ol class="divide-y divide-gray-300 px-4">
      <li></li>
      <li>
        <a
          :href="leaveEditorUrl"
          class="flex justify-center py-5 -ml-4 -mr-4 hover:bg-editor-primary hover:bg-opacity-5 transition-colors duration-200"
          v-tooltip.right="$t('sidebarNav.leaveEditorTooltip')"
        >
          <uikit-icon name="logout-box-r-line" size="1.5rem" />
        </a>
      </li>
    </ol>
  </nav>
</template>

<script>
import ImageLibrary from '@/components/image-library/index.vue'

export default {
  name: 'SidebarNav',
  computed: {
    hasStyle() {
      return !this.isBlank(this.currentStyle)
    },
    isAddSectionPaneActive() {
      return this.$route.name === 'addSection'
    },
    isSectionListPaneActive() {
      return this.$route.name === 'listSections'
    },
    isEditStylePaneActive() {
      return this.$route.name === 'editStyle'
    },
    leaveEditorUrl() {
      return window.leaveUrl
    },
  },
  methods: {
    openImageLibraryModal() {
      this.openModal({
        title: this.$t('imageLibrary.title'),
        component: ImageLibrary,
        props: { modalClass: 'w-216' },
      })
    },
  },
}
</script>
