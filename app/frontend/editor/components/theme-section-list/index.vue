<template>
  <div>
    <category
      v-for="(category, index) in categories"
      :index="index"
      :category="category"
      :insert-after="insertAfter"
    />
  </div>
</template>

<script>
import Category from './category.vue'

export default {
  name: 'ThemeSectionList',
  components: { Category },
  props: {
    insertAfter: { type: String },
  },
  computed: {
    categories() {
      return this.services.theme.buildCategories(this.currentTheme)
    },
  },
}
</script>
