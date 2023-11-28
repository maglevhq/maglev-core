<template>
  <div class="absolute top-0 left-0 mt-2 ml-2 flex">
    <div
      class="bg-editor-primary text-white py-1 px-3 rounded-l-2xl text-xs flex items-center"
      :class="{ 'rounded-r-2xl': !displayMoveArrows }"
    >
      <span>{{ name }}</span>
    </div>
    <button
      type="button"
      class="button"
      @click="moveHoveredSection('up')"
      v-if="displayMoveArrows"
    >
      <uikit-icon name="arrow-up-s-line" />
    </button>
    <button
      type="button"
      class="button button-last"
      @click="moveHoveredSection('down')"
      v-if="displayMoveArrows"
    >
      <uikit-icon name="arrow-down-s-line" />
    </button>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  name: 'SectionHighlighterTopLeftActions',
  props: {
    hoveredSection: { type: Object },
  },
  computed: {
    name() {
      return (
        this.$st(
          `${this.currentI18nScope}.sections.${this.sectionType}.name`,
        ) || this.hoveredSection.name
      )
    },
    sectionType() {
      return this.hoveredSection.definition.id
    },
    displayMoveArrows() {
      return !this.currentSection && !this.hoveredSection.definition.insertAt
    },
  },
  methods: {
    ...mapActions(['moveHoveredSection']),
  },
}
</script>

<style scoped>
.button {
  @apply bg-editor-primary
    py-1
    px-1
    pointer-events-auto
    border-solid 
    border-white 
    border-opacity-25 
    border-0 
    border-l
    text-white text-opacity-75;
}

.button.button-last {
  @apply pr-2 rounded-r-2xl;
}

.button:hover {
  @apply hover:text-opacity-100;
}
</style>
