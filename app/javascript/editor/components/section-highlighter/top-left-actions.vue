<template>
  <div class="absolute top-0 left-0 mt-2 ml-2 flex">
    <div
      class="
        bg-editor-primary
        text-white
        py-1
        px-3
        rounded-l-2xl
        text-xs
        flex
        items-center
      "
      :class="{ 'rounded-r-2xl': !displayMoveArrows }"
    >
      <span>{{ hoveredSection.name }}</span>
    </div>
    <button
      type="button"
      class="button"
      @click="moveHoveredSection('up')"
      v-if="displayMoveArrows"
    >
      <icon name="arrow-up-s-line" />
    </button>
    <button
      type="button"
      class="button button-last"
      @click="moveHoveredSection('down')"
      v-if="displayMoveArrows"
    >
      <icon name="arrow-down-s-line" />
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
    displayMoveArrows() {
      return !this.currentSection
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
