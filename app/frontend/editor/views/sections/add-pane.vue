<template>
  <layout 
    :title="$t('sections.addPane.title')"
    :closeRouteTo="{ name: 'listSections' }"
    with-pre-title
  >
    <template v-slot:pre-title>
      <p class="text-gray-400 text-sm">
        {{ groupLabel }}
      </p>
    </template>

    <theme-section-list 
      :layout-group-id="layoutGroupId"
      :insert-after="sectionId"
      v-if="previewReady" 
    />

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
    layoutGroupId: { type: String },
    sectionId: { type: String },
  },
  computed: {
    groupLabel() {
      return this.$store.getters.layoutGroupDefinition(this.layoutGroupId).label
    }
  }
}
</script>
