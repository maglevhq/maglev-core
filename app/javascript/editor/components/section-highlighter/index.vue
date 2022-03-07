<template>
  <div
    class="h-48 absolute pointer-events-none transition duration-200 ease-in-out"
    :style="style"
    v-if="previewReady"
  >
    <div
      class="w-full h-full relative mx-auto border-solid border-0 border-t-4 border-b-4"
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
        <top-left-actions
          :hovered-section="hoveredSection"
          v-if="hoveredSection"
        />
      </transition>

      <transition name="reverse-slide-fade" mode="out-in">
        <top-right-actions
          :hoveredSection="hoveredSection"
          v-if="hoveredSection"
        />
      </transition>

      <transition name="slide-up-fade" mode="out-in">
        <bottom-actions
          :hovered-section="hoveredSection"
          v-if="hoveredSection"
        />
      </transition>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import TransformationMixin from '@/mixins/preview-transformation'
import TopLeftActions from './top-left-actions'
import TopRightActions from './top-right-actions'
import BottomActions from './bottom-actions'

export default {
  name: 'SectionHighlighter',
  mixins: [TransformationMixin],
  components: { TopLeftActions, TopRightActions, BottomActions },
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
    minTop() {
      return (
        this.services.inlineEditing.getMinTop(
          this.previewDocument,
          this.hoveredSection,
          this.currentSectionList,
        ) || 0
      )
    },
  },
  methods: {
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
      const isSticky = boundingRect.top < this.minTop
      const top = isSticky ? this.minTop : boundingRect.top
      const height = isSticky
        ? boundingRect.height - (this.minTop - boundingRect.top)
        : boundingRect.height

      return {
        top: `${top * this.previewScaleRatio}px`,
        left: `calc(50% - ${this.previewLeftPadding}px / 2 - (${boundingRect.width}px * ${this.previewScaleRatio}) / 2 + ${this.previewLeftPadding}px)`,
        height: `${height * this.previewScaleRatio}px`,
        width: `calc(${boundingRect.width}px * ${this.previewScaleRatio})`,
      }
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
