<template>
  <uikit-accordion
    :key="index"
    headerClass="px-3 py-3 mb-3 bg-editor-primary text-white rounded-sm"
  >
    <div slot="header" class="flex items-center">
      <div class="capitalize-first">{{ name }}</div>
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
</template>

<script>
import ListItem from './list-item.vue'

export default {
  name: 'ThemeSectionListCategory',
  components: { ListItem },
  props: {
    index: { type: Number, required: true },
    category: { type: Object, required: true },
    insertAfter: { type: String },
  },
  computed: {
    name() {
      return this.$st(`${this.currentI18nScope}.categories.${this.category.id}.name`) ?? this.category.name
    },
  },
}
</script>