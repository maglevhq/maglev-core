<template>
  <nav class="h-full w-full">
    <div
      class="flex items-center justify-between h-full w-full animate-pulse"
      v-if="isLoading"
    >
      <div class="h-6 bg-gray-200 rounded w-1/4 mx-6"></div>
      <div class="h-6 bg-gray-200 rounded w-1/4 mx-6"></div>
    </div>
    <div class="flex justify-between h-full w-full" v-else>
      <div class="flex">
        <router-link
          :to="{ name: 'listPages' }"
          class="flex items-center py-4 px-6 flex-row hover:bg-editor-primary hover:bg-opacity-5 transition-colors duration-200"
          :class="{
            'bg-white': !isListPagesActive,
            'bg-editor-primary bg-opacity-5': isListPagesActive,
          }"
        >
          <span>{{ $t('headerNav.pages') }}</span>
          <page-icon class="ml-4" :page="currentPage" />
          <span class="ml-2">{{ currentPage.title }}</span>
          <icon name="arrow-down-s-line" class="ml-3" />
        </router-link>

        <separator />

        <router-link
          :to="{ name: 'editPageSettings' }"
          class="flex items-center py-4 px-6 flex-row hover:bg-editor-primary hover:bg-opacity-5 transition-colors duration-200"
          :class="{
            'bg-white': !isEditPageActive,
            'bg-editor-primary bg-opacity-5': isEditPageActive,
          }"
        >
          <icon name="settings-4-line" size="1.25rem" />
          <span class="ml-2">{{ $t('headerNav.pageSettings') }}</span>
        </router-link>

        <separator />
      </div>

      <div class="flex">
        <div class="flex py-4 px-6">
          <device-toggler />
        </div>
        <separator />

        <div class="flex h-full relative" v-if="hasMultipleLocales">
          <locale-toggler />
        </div>
        <separator v-if="hasMultipleLocales" />

        <preview-toggler v-if="isSitePublishable" />
        <preview-button v-else />

        <separator v-if="isSitePublishable" />
        <div
          class="flex items-center h-full relative space-x-1 pr-4"
          v-if="isSitePublishable"
        >
          <publish-button />
          <save-button />
        </div>

        <div v-else>
          <save-button :big="true" />
        </div>
      </div>
    </div>
  </nav>
</template>

<script>
import DeviceToggler from './device-toggler.vue'
import LocaleToggler from './locale-toggler/index.vue'
import PreviewButton from './preview-button.vue'
import PreviewToggler from './preview-toggler.vue'
import PublishButton from './publish-button.vue'
import SaveButton from './save-button.vue'
import Separator from './separator.vue'

export default {
  name: 'HeaderNav',
  components: {
    DeviceToggler,
    LocaleToggler,
    PreviewButton,
    PublishButton,
    SaveButton,
    Separator,
    PreviewToggler,
  },
  computed: {
    isLoading() {
      return !this.currentSite || !this.currentPage
    },
    isListPagesActive() {
      return this.$route.name === 'listPages'
    },
    isEditPageActive() {
      return this.$route.name === 'editPageSettings'
    },
  },
}
</script>
