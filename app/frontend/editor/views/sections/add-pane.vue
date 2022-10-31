<template>
  <layout :title="$t('sections.addPane.title')">
    <theme-section-list :insertAfter="sectionId" v-if="previewReady" />
    <div class="h-full w-full animate-pulse" v-else>
      <div class="w-full bg-gray-200 rounded h-12 mb-3"></div>
      <div class="w-full bg-gray-200 rounded h-12 mb-3"></div>
      <div class="w-full bg-gray-200 rounded h-12 mb-3"></div>
    </div>
  </layout>
</template>

<script>
import Layout from '@/layouts/slide-pane.vue'
import ThemeSectionList from '@/components/theme-section-list/index.vue'

export default {
  name: 'SectionListPane',
  components: { Layout, ThemeSectionList },
  props: {
    sectionId: { type: String },
  },
}
</script>
