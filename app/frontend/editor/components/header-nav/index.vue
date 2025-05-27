<template>
  <nav class="h-full w-full">
    <div
      class="flex items-center justify-between h-full w-full animate-pulse"
      v-if="isLoading"
    >
      <div class="h-6 bg-gray-200 rounded w-1/4 mx-6"></div>
      <div class="h-6 bg-gray-200 rounded w-1/4 mx-6"></div>
    </div>
    <div class="grid grid-cols-5 h-full w-full" v-else>
      <div class="col-span-3 lg:col-span-2">
        <page-info />
      </div>

      <div class="col-span-1 hidden lg:flex justify-center">
        <device-toggler />
      </div>

      <div class="col-span-2 flex justify-end h-full">
        <div class="flex h-full relative" v-if="hasMultipleLocales">
          <locale-toggler />
        </div>
        <separator v-if="hasMultipleLocales" />

        <preview-toggler v-if="isSitePublishable" />
        <preview-button v-else class="hidden lg:flex" />

        <separator v-if="isSitePublishable" />
        
        <div
          class="flex items-center h-full relative space-x-1 pr-4"
          v-if="isSitePublishable"
        >
          <publish-button />
          <save-button />
        </div>

        <div v-else>
          <save-button big />
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
import PageInfo from './page-info.vue'

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
    PageInfo,
  },
  computed: {
    isLoading() {
      return !this.currentSite || !this.currentPage
    },
    isListPagesActive() {
      return this.$route.name === 'listPages'
    },    
  },
}
</script>
