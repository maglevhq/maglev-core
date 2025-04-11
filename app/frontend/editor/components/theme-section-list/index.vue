<template>
  <div class="space-y-4">
    <uikit-accordion
      v-for="(category, index) in categories"
      :key="index"
      headerClass="px-3 py-3 mb-3 bg-editor-primary text-white rounded-sm"
    >
      <div slot="header" class="flex items-center">
        <div class="capitalize-first">{{ category.label }}</div>
        <div class="ml-2 px-3 bg-white bg-opacity-25 text-xs rounded-full">
          {{ category.children.length }}
        </div>
      </div>
      <div class="pt-1">
        <list-item
          v-for="section in category.children"
          :key="section.id"
          :section="section"
          :layout-group-id="layoutGroupId"
          :insert-after="insertAfter"
        />

        <div
          class="text-center pt-2 pb-6"
          v-if="category.children.length === 0"
        >
          {{ $t('themeSectionList.emptyCategory') }}
        </div>
      </div>
    </uikit-accordion>

    <div v-if="noCategories" class="text-center mt-8 space-y-1">
      <h3 class="text-gray-800 font-semibold">{{ $t('themeSectionList.empty.title') }}</h3>
      <p class="text-gray-600 text-sm">{{ $t('themeSectionList.empty.message') }}</p>
    </div>

    <mirror-section-button 
      :layoutGroupId="layoutGroupId" 
      :insertAfter="insertAfter"
      v-if="allowSectionMirroring"
    />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import ListItem from './list-item.vue'
import MirrorSectionButton from './mirror-button.vue'

export default {
  name: 'ThemeSectionList',
  components: { ListItem, MirrorSectionButton },
  props: {
    layoutGroupId: { type: String, required: true },
    insertAfter: { type: String },
  },
  data() {
    return { activeCategory: null }
  },
  computed: {
    ...mapGetters(['categoriesByLayoutGroupId']),
    categories() {
      return this.categoriesByLayoutGroupId(this.layoutGroupId)
    },
    noCategories() {
      return this.categories.length === 0
    },
    canAddMirroredSection() {
      return this.services.section.canAddMirroredSection({ 
        numberOfPages: this.currentSite.numberOfPages 
      })
    },
    allowSectionMirroring() {
      return this.currentTheme.mirrorSection && this.canAddMirroredSection
    }
  },
}
</script>
