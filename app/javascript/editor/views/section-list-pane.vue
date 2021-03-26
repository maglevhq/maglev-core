<template>
  <layout :title="$t('sectionList.title')">
    <section-list v-if="previewReady" />
    <div class="h-full w-full animate-pulse" v-else>
      <div class="w-full bg-gray-200 rounded h-12 mb-3"></div>
      <div class="w-full bg-gray-200 rounded h-12 mb-3"></div>
      <div class="w-full bg-gray-200 rounded h-12 mb-3"></div>
    </div>
  </layout>
</template>

<script>
import Layout from '@/layouts/slide-pane'
import SectionList from '@/components/theme-section-list'

export default {
  name: 'SectionListPane',
  components: { Layout, SectionList },  
}
</script>
