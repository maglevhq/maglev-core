<template>
  <nav class="h-full w-full">
    <div
      class="flex items-center justify-between h-full w-full animate-pulse"
      v-if="!currentPage"
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

        <div class="flex h-full relative">
          <locale-toggler />
        </div>

        <separator />

        <a
          :href="currentPage.previewUrl"
          target="_blank"
          class="px-6 flex items-center hover:bg-editor-primary hover:bg-opacity-5 transition-colors duration-200"
        >
          {{ $t('headerNav.previewSite') }}
        </a>
        <div>
          <save-button />
        </div>
      </div>
    </div>
  </nav>
</template>

<script>
import DeviceToggler from './device-toggler'
import LocaleToggler from './locale-toggler'
import SaveButton from './save-button'
import Separator from './separator'

export default {
  name: 'HeaderNav',
  components: { DeviceToggler, LocaleToggler, SaveButton, Separator },
  computed: {
    isListPagesActive() {
      return this.$route.name === 'listPages'
    },
    isEditPageActive() {
      return this.$route.name === 'editPageSettings'
    },
  },
}
</script>
