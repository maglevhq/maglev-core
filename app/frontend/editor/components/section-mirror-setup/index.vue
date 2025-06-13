<template>
  <div class="flex flex-col h-full">
    <div 
      class="text-red-700 bg-red-100 text-sm py-3 px-4 rounded mb-4"
      v-if="doesDisplayErrors"
      v-html="$t('mirrorSectionSetup.errorMessage')"
    />
     
    <div class="flex-1 overflow-y-scroll space-y-6 px-1">
      <section-selector v-model="source" />
    </div>

    <section-actions
      :disabled="!isValid"
      @confirm="onConfirm"
      v-on="$listeners"
      class="mt-auto"
    />
  </div>
</template>

<script>
import SectionSelector from './selector.vue'
import SectionActions from './actions.vue'

export default {
  name: 'SectionMirrorSetup',
  components: { SectionSelector, SectionActions },
  data() {
    return { 
      source: { 
        pageId: null,
        pageTitle: null,
        layoutGroupId: null,
        sectionId: null
      } 
    }
  },
  computed: {
    isFilled() {
      return (
        !this.isBlank(this.source.pageId) && 
        !this.isBlank(this.source.layoutGroupId) &&
        !this.isBlank(this.source.sectionId)
      )
    },
    isValid() {
      return this.isFilled && this.services.section.canAddMirroredSection({ 
        numberOfPages: this.currentSite.numberOfPages,
        page: this.currentPage,
        sections: this.currentSections,
        mirrorOf: this.source
      })
    },
    doesDisplayErrors() {
      return this.isFilled && !this.isValid
    }
  },
  methods: {
    onConfirm() {
      this.$emit('setup', { ...this.source })
    }
  }
}
</script>

