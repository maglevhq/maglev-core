<template>
  <div>
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
          :insertAfter="insertAfter"
        />

        <div
          class="text-center pt-2 pb-6"
          v-if="category.children.length === 0"
        >
          {{ $t('themeSectionList.emptyCategory') }}
        </div>
      </div>
    </uikit-accordion>
  </div>
</template>

<script>
import ListItem from './list-item.vue'

export default {
  name: 'ThemeSectionList',
  components: { ListItem },
  props: {
    insertAfter: { type: String },
  },
  data() {
    return { activeCategory: null }
  },
  computed: {
    categories() {
      return this.services.theme.buildCategories(this.currentTheme)
    },
  },
}
</script>
