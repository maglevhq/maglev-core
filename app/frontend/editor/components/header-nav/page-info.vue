<template>
  <div class="flex flex-row items-center h-full w-full px-4 overflow-hidden">
    <div class="flex flex-col leading-none overflow-hidden">
      <div class="flex items-center">
        <uikit-page-icon :page="currentPage" size="1.1rem" class="shrink-0 text-gray-900" />
        <div class="text-base font-semibold truncate ml-1 mr-3">{{ currentPage.title }}</div>

        <page-actions-button 
          :page="currentPage" 
          compact
          @on-clone="goToClonedPage"
        />
      </div>
      <div class="text-xs text-gray-500 flex items-center space-x-1">
        <p class="truncate text-gray-700">
          <span class="text-gray-900 font-semibold">{{ currentPagePath[0] }}</span>{{ currentPagePath.slice(1) }}
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import PageActionsButton from '../page/list/actions-button.vue'

export default {
  name: 'PageInfo',
  components: {
    PageActionsButton,
  },
  computed: {
    ...mapGetters(['currentPagePath', 'currentPageUrl']),    
  },
  methods: {
    goToClonedPage(page) {
      this.$router.push({ name: 'editPage', params: { pageId: page.path } })
    },
  },
}
</script>