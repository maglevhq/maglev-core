<template>
  <div class="flex flex-col h-full">
    <div class="flex-1 overflow-y-scroll space-y-6 px-1">
      <!-- <uikit-checkbox-input
        :label="$t(`mirrorSectionSetup.enabled`)"
        name="enabled"
        v-model="enabled"
      /> -->

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
    isValid() {
      return (
        !this.isBlank(this.source.pageId) && 
        !this.isBlank(this.source.layoutGroupId) &&
        !this.isBlank(this.source.sectionId)
      )
    },
  },
  methods: {
    onConfirm() {
      this.$emit('setup', { ...this.source })
    }
  }
}
</script>

