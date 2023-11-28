<template>
  <div
    class="absolute bottom-0 flex justify-center w-full"
    v-if="displayInsertButton"
  >
    <router-link
      :to="{
        name: 'addSectionAfter',
        params: { sectionId: hoveredSection.sectionId },
      }"
      custom
      v-slot="{ navigate }"
    >
      <button
        type="button"
        @click="navigate"
        @keypress.enter="navigate"
        class="button top-4"
      >
        <uikit-icon name="ri-add-line" size="1.5rem" />
      </button>
    </router-link>
  </div>
</template>

<script>
export default {
  name: 'SectionHighlighterBottomActions',
  props: {
    hoveredSection: { type: Object },
  },
  computed: {
    displayInsertButton() {
      if (!this.hoveredSection) return false
      const { definition } = this.hoveredSection
      return definition.insertButton
    },
  },
}
</script>

<style scoped>
.button {
  @apply bg-editor-primary
    pointer-events-auto
    flex
    items-center
    justify-center
    h-8
    w-8
    rounded-full
    text-white
    text-opacity-75
    relative;
}

.button:hover {
  @apply text-opacity-100;
}
</style>
