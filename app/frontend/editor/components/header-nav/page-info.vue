<template>
  <div class="flex items-center h-full px-4 flex-row w-full overflow-hidden">
    <uikit-page-icon :page="currentPage" size="1.75rem" class="shrink-0" />
    <div class="ml-4 flex flex-col leading-none overflow-hidden">
      <div class="text-base font-semibold truncate">{{ currentPage.title }}</div>
      <div class="text-xs text-gray-500 -mt-0.5 flex items-center space-x-1">
        <span class="truncate">{{ currentPagePath }}</span>
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