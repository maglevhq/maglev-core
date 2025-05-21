<template>
  <router-link
    :to="{ name: 'listPages' }"
    class="flex items-center h-full px-6 flex-row hover:bg-editor-primary hover:bg-opacity-5 transition-colors duration-200"
    :class="{
      'bg-white': !isListPagesActive,
      'bg-editor-primary bg-opacity-5': isListPagesActive,
    }"
  >
    <uikit-page-icon :page="currentPage" size="1.5rem" />
    <div class="ml-4 flex flex-col leading-none">
      <span class="text-base">{{ currentPage.title }}</span>
      <span class="text-xs text-gray-500 -mt-1 truncate">/{{ currentPage.path }}</span>
    </div>
    <uikit-icon name="arrow-down-s-line" class="ml-3" />
  </router-link>
</template>

<script>
export default {
  name: 'PageInfo',
  computed: {
    isListPagesActive() {
      return this.$route.name === 'listPages'
    },
  }
}
</script>


