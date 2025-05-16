<template>
  <div
    class="bg-gray-100 rounded-md px-4 py-3 flex items-center justify-between text-gray-800 cursor-move"
  >
    <router-link
      :to="{ name: 'editSection', params: { sectionId: section.id } }"
      class="flex items-center"
    >
      <span>{{ name | truncate(40) }}</span>
    </router-link>
    <uikit-confirmation-button
      @confirm="removeSection(section.id)"
      v-on="$listeners"
    >
      <uikit-list-item-button iconName="delete-bin-line" />      
    </uikit-confirmation-button>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  name: 'SectionListItem',
  props: {
    section: { type: Object, required: true },
  },
  computed: {
    name() {
      return (
        this.$st(
          `${this.currentI18nScope}.sections.${this.section.type}.name`,
        ) || this.section.name
      )
    },
  },
  methods: {
    ...mapActions(['removeSection']),
  },
}
</script>
