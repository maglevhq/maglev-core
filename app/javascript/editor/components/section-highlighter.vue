<template>
  <div
    class="
      h-48
      absolute
      pointer-events-none
      transition
      duration-200
      ease-in-out
    "
    :style="style"
    v-if="previewReady"
  >
    <div
      class="
        w-full
        h-full
        relative
        mx-auto
        border-solid border-0 border-t-4 border-b-4
      "
      :class="{
        tablet: hasEnoughWidthForTablet,
        mobile: hasEnoughWidthForMobile,
        'border-transparent': !hoveredSection,
        'border-editor-primary': hoveredSection,
      }"
    >
      <transition
        name="slide-fade"
        mode="out-in"
        v-on:after-leave="afterAnimationDone"
      >
        <div class="absolute top-0 left-0 mt-2 ml-2 flex" v-if="hoveredSection">
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
            class="
              bg-editor-primary
              py-1
              px-1
              pointer-events-auto
              border-solid border-white border-opacity-25 border-0 border-l
              text-white text-opacity-75
              hover:text-opacity-100
            "
            @click="moveHoveredSection('up')"
            v-if="displayMoveArrows"
          >
            <icon name="arrow-up-s-line" />
          </button>
          <button
            type="button"
            class="
              bg-editor-primary
              py-1
              pl-1
              pr-2
              pointer-events-auto
              border-solid border-white border-opacity-25 border-0 border-l
              rounded-r-2xl
              text-white text-opacity-75
              hover:text-opacity-100
            "
            @click="moveHoveredSection('down')"
            v-if="displayMoveArrows"
          >
            <icon name="arrow-down-s-line" />
          </button>
        </div>
      </transition>

      <transition name="reverse-slide-fade" mode="out-in">
        <div
          class="absolute top-0 right-0 mt-2 mr-2 flex"
          v-if="hoveredSection"
        >
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
              class="
                bg-white
                rounded-full
                shadow-xl
                h-8
                w-8
                flex
                items-center
                justify-center
                text-gray-700
                hover:text-black
                pointer-events-auto
              "
            >
              <icon name="ri-pencil-line" />
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
              class="
                ml-2
                bg-white
                rounded-full
                shadow-xl
                h-8
                w-8
                flex
                items-center
                justify-center
                text-gray-700
                hover:text-black
                pointer-events-auto
              "
            >
              <icon name="ri-play-list-add-line" />
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
              class="
                ml-2
                bg-white
                rounded-full
                shadow-xl
                h-8
                w-8
                flex
                items-center
                justify-center
                text-gray-700
                hover:text-black
                pointer-events-auto
              "
            >
              <icon name="ri-settings-5-line" />
            </button>
          </router-link>

          <confirmation-button
            class="ml-2 pointer-events-auto"
            @confirm="remove"
          >
            <div
              class="
                bg-white
                rounded-full
                shadow-xl
                h-8
                w-8
                flex
                items-center
                justify-center
                text-gray-700
                hover:text-black
              "
            >
              <icon name="delete-bin-line" />
            </div>
          </confirmation-button>
        </div>
      </transition>
    </div>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex'
import TransformationMixin from '@/mixins/preview-transformation'

export default {
  name: 'SectionHighlighter',
  mixins: [TransformationMixin],
  props: {
    hoveredSection: { type: Object },
  },
  data() {
    return { shadow: null }
  },
  mounted() {
    // NOTE: optimized version to update the highlighter when scrolling the iframe
    window.addEventListener('maglev:preview:scroll', this.onPreviewScroll)
  },
  beforeDestroy() {
    window.removeEventListener('maglev:preview:scroll', this.onPreviewScroll)
  },
  computed: {
    ...mapState(['previewDocument']),
    style() {
      if (!this.hoveredSection && !this.shadow) return {}
      const { el } = this.hoveredSection || this.shadow
      const rect = el.getBoundingClientRect()
      return this.performStyle(rect)
    },
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
    displayMoveArrows() {
      return !this.currentSection
    },
  },
  methods: {
    ...mapActions(['moveHoveredSection', 'removeSection', 'leaveSection']),
    afterAnimationDone() {
      this.shadow = null
    },
    onPreviewScroll(event) {
      let self = this
      window.requestAnimationFrame(() => {
        const newStyle = this.performStyle(event.detail.boundingRect)
        Object.entries(newStyle).forEach(
          ([key, value]) => (self.$el.style[key] = value),
        )
        self.previewDocument.ticking = false
      })
    },
    performStyle(boundingRect) {
      return {
        top: `${boundingRect.top * this.previewScaleRatio}px`,
        left: `calc(50% - ${this.previewLeftPadding}px / 2 - (${boundingRect.width}px * ${this.previewScaleRatio}) / 2 + ${this.previewLeftPadding}px)`,
        height: `${boundingRect.height * this.previewScaleRatio}px`,
        width: `calc(${boundingRect.width}px * ${this.previewScaleRatio})`,
      }
    },
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
  watch: {
    hoveredSection(value, oldValue) {
      if (!value) {
        this.shadow = { ...oldValue }
      }
    },
  },
}
</script>

<style scoped>
.mobile {
  width: 375px;
}

.tablet {
  width: 1024px;
}
</style>
