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
          :to="{ name: 'addSection' }"
          class="
            flex
            justify-center
            py-5
            -ml-4
            -mr-4
            hover:bg-editor-primary hover:bg-opacity-5
            transition-colors
            duration-200
          "
          :class="{
            'bg-white': !isAddSectionPaneActive,
            'bg-editor-primary bg-opacity-5': isAddSectionPaneActive,
          }"
        >
          <icon name="add-box-line" size="1.5rem" />
        </router-link>
      </li>
      <li>
        <router-link
          :to="{ name: 'listSections' }"
          class="
            flex
            justify-center
            py-5
            -ml-4
            -mr-4
            hover:bg-editor-primary hover:bg-opacity-5
            transition-colors
            duration-200
          "
          :class="{
            'bg-white': !isSectionListPaneActive,
            'bg-editor-primary bg-opacity-5': isSectionListPaneActive,
          }"
        >
          <icon name="ri-stack-line" size="1.5rem" />
        </router-link>
      </li>
      <li>
        <a
          href="#"
          class="
            flex
            justify-center
            py-5
            -ml-4
            -mr-4
            hover:bg-editor-primary hover:bg-opacity-5
            transition-colors
            duration-200
          "
          @click.prevent="openImageLibraryModal"
        >
          <icon name="image-line" size="1.5rem" />
        </a>
      </li>
      <li>
        <router-link
          :to="{ name: 'test', params: { pageId: currentPage.path } }"
          class="
            flex
            justify-center
            py-5
            -ml-4
            -mr-4
            hover:bg-editor-primary hover:bg-opacity-5
            transition-colors
            duration-200
          "
        >
          T
        </router-link>
      </li>
      <li>
        <router-link
          :to="{ name: 'test2', params: { pageId: currentPage.path } }"
          class="
            flex
            justify-center
            py-5
            -ml-4
            -mr-4
            hover:bg-editor-primary hover:bg-opacity-5
            transition-colors
            duration-200
          "
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
          class="
            flex
            justify-center
            py-5
            -ml-4
            -mr-4
            hover:bg-editor-primary hover:bg-opacity-5
            transition-colors
            duration-200
          "
        >
          <icon name="logout-box-r-line" size="1.5rem" />
        </a>
      </li>
    </ol>
  </nav>
</template>

<script>
import ImageLibrary from '@/components/image-library'

export default {
  name: 'SidebarNav',
  computed: {
    isAddSectionPaneActive() {
      return this.$route.name === 'addSection'
    },
    isSectionListPaneActive() {
      return this.$route.name === 'listSections'
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
