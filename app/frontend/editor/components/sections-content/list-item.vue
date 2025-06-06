<template>
  <div
    class="bg-gray-100 hover:bg-gray-200 rounded-md px-4 py-3 flex items-center justify-between text-gray-800 cursor-move"
  >
    <div class="flex items-center space-x-2">
      <router-link
        :to="{ name: 'editSection', params: { sectionId: section.id } }"
        class="flex items-center"
      >
        <span>{{ name | truncate(40) }}</span>
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
