<template>
  <div class="flex flex-row items-center h-full w-full px-4 overflow-hidden">
    <div class="flex flex-col leading-none overflow-hidden">
      <div class="flex items-center space-x-1">
        <uikit-page-icon :page="currentPage" size="1.1rem" class="shrink-0 text-gray-900" />
        <div class="text-base font-semibold truncate">{{ currentPage.title }}</div>
      </div>
      <div class="text-xs text-gray-500 flex items-center space-x-1">
        <p class="truncate text-gray-700"><span class="text-gray-900 font-semibold">{{ currentPagePath[0] }}</span>{{ currentPagePath.slice(1) }}</p>
        <uikit-copy-paste-button :text-to-copy="currentPageUrl" />
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'PageInfo',
  computed: {
    ...mapGetters(['currentPagePath', 'currentPageUrl']),    
  }
}
</script>