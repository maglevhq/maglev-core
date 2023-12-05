<template>
  <div class="absolute top-0 right-0 mt-2 mr-2 flex">
    <router-link
      :to="{
        name: 'editSection',
        params: { sectionId: hoveredSection.sectionId },
      }"
      custom
      v-slot="{ navigate }"
      v-if="hasSettings"
    >
      <button
        type="button"
        @click="navigate"
        @keypress.enter="navigate"
        class="ml-2 button"
      >
        <uikit-icon name="ri-pencil-line" />
      </button>
    </router-link>

    <router-link
      :to="{
        name: 'editSection',
        params: { sectionId: hoveredSection.sectionId },
        hash: '#blocks',
      }"
      custom
      v-slot="{ navigate }"
      v-if="hasBlocks"
    >
      <button
        type="button"
        @click="navigate"
        @keypress.enter="navigate"
        class="ml-2 button"
      >
        <uikit-icon name="ri-play-list-add-line" />
      </button>
    </router-link>

    <router-link
      :to="{
        name: 'editSection',
        params: { sectionId: hoveredSection.sectionId },
        hash: '#advanced',
      }"
      custom
      v-slot="{ navigate }"
      v-if="hasAdvancedSettings"
    >
      <button
        type="button"
        @click="navigate"
        @keypress.enter="navigate"
        class="ml-2 button"
      >
        <uikit-icon name="ri-settings-5-line" />
      </button>
    </router-link>

    <uikit-confirmation-button
      class="ml-2 pointer-events-auto"
      @confirm="remove"
    >
      <div class="button">
        <uikit-icon name="delete-bin-line" />
      </div>
    </uikit-confirmation-button>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  name: 'SectionHighlighterTopRightActions',
  props: {
    hoveredSection: { type: Object },
  },
  computed: {
    hasSettings() {
      const { definition } = this.hoveredSection
      return !this.isBlank(this.services.section.getSettings(definition, false))
    },
    hasAdvancedSettings() {
      const { definition } = this.hoveredSection
      return !this.isBlank(this.services.section.getSettings(definition, true))
    },
    hasBlocks() {
      const {
        definition: { blocks },
      } = this.hoveredSection
      return !this.isBlank(blocks)
    },
  },
  methods: {
    ...mapActions(['removeSection', 'leaveSection']),
    remove() {
      const sectionId = this.hoveredSection.sectionId
      this.leaveSection()
      if (
        this.currentSection &&
        this.currentSection.id === this.hoveredSection.sectionId
      )
        this.$router.push({ name: 'editPage' })
      // waiting for the animation to finish
      setTimeout(() => this.removeSection(sectionId), 200)
    },
  },
}
</script>

<style scoped>
.button {
  @apply bg-white
    rounded-full
    shadow-xl
    h-8
    w-8
    flex
    items-center
    justify-center
    text-gray-700
    pointer-events-auto;
}
.button:hover {
  @apply hover:text-black;
}
</style>
