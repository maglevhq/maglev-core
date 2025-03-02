<template>
  <div
    class="h-48 absolute pointer-events-none transition duration-200 ease-in-out"
    :style="{...style}"
    v-if="previewReady"
  >
    <div
      class="w-full h-full relative mx-auto border-solid border-0 border-t-4 border-b-4"
      :class="{
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
import TransformationMixin from '@/mixins/preview-transformation'
import TopLeftActions from './top-left-actions.vue'
import TopRightActions from './top-right-actions.vue'
import BottomActions from './bottom-actions.vue'

export default {
  name: 'SectionHighlighter',
  mixins: [TransformationMixin],
  components: { TopLeftActions, TopRightActions, BottomActions },
  props: {
    hoveredSection: { type: Object },
  },
  data() {
    return { shadow: null, style: {} }
  },
  mounted() {
    // NOTE: optimized version to update the highlighter when scrolling the iframe
    window.addEventListener('maglev:preview:scroll', this.onPreviewScroll)
  },
  beforeDestroy() {
    window.removeEventListener('maglev:preview:scroll', this.onPreviewScroll)
  },
  computed: {
    minTop() {
      return this.hoveredSection?.sectionOffsetTop || 0
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
        left: `calc(${this.calculateLeftOffset()}px + (${boundingRect.left}px * ${this.previewScaleRatio}))`,
        height: `${height * this.previewScaleRatio}px`,
        width: `calc(${boundingRect.width}px * ${this.previewScaleRatio})`,
      }
    },
    calculateLeftOffset() {
      const sidebarWidth =
        document.querySelector('.content-area > aside')?.offsetWidth || 0
      const iframePadding = document.getElementById('iframe-wrapper').getBoundingClientRect().left
      return iframePadding - sidebarWidth
    }, 
  },
  watch: {
    hoveredSection(value, oldValue) {
      if (!value) this.shadow = { ...oldValue }
      
      if (!this.hoveredSection && !this.shadow) {
        this.style = {}
        return
      }

      const { sectionRect } = value || this.shadow
      this.style = this.performStyle(sectionRect)
    },
  },
}
</script>