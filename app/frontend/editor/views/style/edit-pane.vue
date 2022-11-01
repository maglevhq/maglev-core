<template>
  <layout :title="$t('style.edit.title')" :overflowY="false">
    <style-pane v-if="previewReady" class="pb-4" />
    <div class="mx-4" v-else>
      <div class="h-full w-full animate-pulse">
        <div class="w-full bg-gray-200 rounded h-20 mb-3"></div>
        <div class="w-full bg-gray-200 rounded h-20 mb-3"></div>
        <div class="w-full bg-gray-200 rounded h-20 mb-3"></div>
      </div>
    </div>
  </layout>
</template>

<script>
import Layout from '@/layouts/slide-pane.vue'
import StylePane from '@/components/style-pane/index.vue'

export default {
  name: 'SectionListPane',
  components: { Layout, StylePane },
}
</script>
