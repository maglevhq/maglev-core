<template>
  <div class="divide-y">
    <section-list 
      v-for="layoutGroup in sectionsContent"
      :key="['layout-group', layoutGroup.id].join('-')"
      :layout-group="layoutGroup"
      class="py-2"
    />
  </div>
</template>

<script>
import SectionList from './list.vue'

export default {
  name: 'SectionsContent',
  components: { SectionList },
  computed: {
    sectionsContent() {
      return this.currentSectionsContent
    },
  }
}
</script>