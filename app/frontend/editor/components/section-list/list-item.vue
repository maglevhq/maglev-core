<template>
  <div
    class="bg-gray-100 rounded-md pr-2 flex items-center text-gray-800 relative"
  >
    <add-button insertAt="top" v-if="isFirst" />
    <add-button :insertAt="section.id" />

    <div class="flex flex-col cursor-move px-2 py-3">
      <uikit-icon name="ri-draggable" />
    </div>

    <router-link
      :to="{ name: 'editSection', params: { sectionId: section.id } }"
      class="flex flex-col overflow-hidden py-3 pr-2 leading-0.5 flex-1"
    >
      <span :class="{ 'text-gray-500 text-xs': label }">{{ name | truncate(40) }}</span>
      <span class="text-gray-800 truncate" v-if="label">{{ label | truncate(100) }}</span>
    </router-link>

    <uikit-confirmation-button
      @confirm="removeSection(section.id)"
      v-on="$listeners"
      class="ml-auto"
    >
      <uikit-icon-button iconName="delete-bin-line" />
    </uikit-confirmation-button>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import AddButton from './add-button.vue'

export default {
  name: 'SectionListItem',
  components: { AddButton },
  props: {
    section: { type: Object, required: true },
    index: { type: Number, required: true },
  },
  computed: {
    name() {
      return (
        this.$st(
          `${this.currentI18nScope}.sections.${this.section.type}.name`,
        ) || this.section.name
      )
    },
    label() {
      return this.section.label
    },
    isFirst() {
      return this.index === 0
    },
  },
  methods: {
    ...mapActions(['removeSection']),
  },
}
</script>
