<template>
  <div
    class="bg-gray-100 rounded-md pr-4 flex items-center text-gray-800"
  >
  <div class="flex flex-col cursor-move px-4 py-3">
      <uikit-icon name="ri-expand-up-down-line" />
    </div>
    <div class="flex items-center space-x-2">
      <router-link
      :to="{ name: 'editSection', params: { sectionId: section.id } }"
      class="flex flex-col overflow-hidden py-3"
    >
      <span :class="{ 'text-gray-800': label }">{{ name | truncate(40) }}</span>
      <span class="text-gray-500 text-sm truncate" v-if="label">{{ label | truncate(100) }}</span>
    </router-link>
      <uikit-icon
        name="ri-links-line" 
        size="0.9rem" 
        class="text-black"
        v-tooltip="mirroredTooltip"
        v-if="section.isMirrored" 
      />
    </div>
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
    label() {
      return this.section.label
    },
    mirroredTooltip() {
      return {
        placement: 'right-end',
        autoHide: false,
        content: this.$t('mirrorSectionSetup.tooltip', { pageTitle: this.section.mirroredPageTitle })
      }
    }
  },
  methods: {
    ...mapActions(['removeSection']),
  },
}
</script>
