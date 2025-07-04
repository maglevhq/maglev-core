<template>
  <div
    class="relative mb-6 w-full transition duration-150 ease-in-out transform hover:-translate-y-1 border border-gray-200"
    :class="{
      'cursor-pointer': canBeAdded,
      'cursor-not-allowed': !canBeAdded,
    }"
    @click="select"
  >
    <img
      class="w-full"
      :class="{ hidden: !isImageLoaded || isImageNotFound }"
      :src="section.screenshotPath"
      @load="imageLoaded"
      @error="imageNotFound"
      v-if="hasScreenshot"
    />
    <div
      class="bg-gray-200 w-full h-16 animate-pulse"
      v-if="!isImageLoaded && !isImageNotFound"
    >
      &nbsp;
    </div>
    <div
      class="bg-white w-full h-16 flex items-center justify-center"
      v-if="isImageNotFound"
    >
      <uikit-icon name="ri-bug-line" />
    </div>
    <div
      class="flex items-center px-2 bg-editor-primary bg-opacity-5 py-4 w-full font-bold text-sm"
    >
      <p class="capitalize-first">{{ name }}</p>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  name: 'ThemeSectionListItem',
  props: {
    section: { type: Object, required: true, default: null },
    insertAfter: { type: String },
  },
  data() {
    return { hovered: false, isImageLoaded: false, isImageNotFound: false }
  },
  computed: {
    name() {
      return (
        this.$st(
          `${this.currentI18nScope}.sections.${this.section.id}.name`,
        ) || this.section.name
      )
    },
    hasScreenshot() {
      return this.section.screenshotPath
    },
    canBeAdded() {
      return this.services.section.canBeAddedToPage(
        this.section,
        this.currentSectionList,
      )
    },
  },
  methods: {
    ...mapActions(['addSection']),
    select() {
      if (!this.canBeAdded) return
      this.addSection({
        sectionDefinition: this.section,
        insertAt: this.insertAfter,
      }).then(section => {
        this.$router.push({ name: 'editSection', params: { sectionId: section.id } })
      })
    },
    imageLoaded() {
      // console.log('imageLoaded', this.section.name, event)
      this.isImageLoaded = true
    },
    imageNotFound(event) {
      console.log('imageNotFound', this.section.name, event)
      this.isImageNotFound = true
    },
  },
}
</script>

<style scoped>
.min-height {
  min-height: theme('spacing.16');
}
</style>
