<template>
  <div
    class="h-48 absolute pointer-events-none transition duration-200 ease-in-out"
    :style="{...style}"
    v-if="previewReady"
  >
    <div
      class="w-full h-full relative mx-auto border-solid border-0 border-t-4 border-b-4"
      :class="{
        'border-transparent': !mustBeDisplayed,
        'border-editor-primary': mustBeDisplayed,
      }"
    >
      <transition
        name="slide-fade"
        mode="out-in"
      >
        <top-left-actions
          :hovered-section="hoveredSection"
          v-if="mustBeDisplayed"
        />
      </transition>

      <transition name="reverse-slide-fade" mode="out-in">
        <top-right-actions
          :hoveredSection="hoveredSection"
          v-if="mustBeDisplayed"
        />
      </transition>

      <transition name="slide-up-fade" mode="out-in">
        <bottom-actions
          :hovered-section="hoveredSection"
          v-if="mustBeDisplayed"
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
import { debounce } from '@/misc/utils'

export default {
  name: 'SectionHighlighter',
  mixins: [TransformationMixin],
  components: { TopLeftActions, TopRightActions, BottomActions },
  props: {
    hoveredSection: { type: Object },
  },
  data() {
    return { style: {}, isScrolling: false, boundingRect: null }
  },
  mounted() {
    window.addEventListener('maglev:preview:scroll', this.onPreviewScroll)
    this.waitUntilScrollingDone = debounce(this.onEndPreviewScrolling.bind(this), 800)
  },
  beforeDestroy() {
    window.removeEventListener('maglev:preview:scroll', this.onPreviewScroll)
  },
  computed: {
    minTop() {
      return this.hoveredSection?.sectionOffsetTop || 0
    },
    mustBeDisplayed() {
      return !!this.hoveredSection && !this.isScrolling
    }
  },
  methods: {
    onPreviewScroll(event) {      
      this.isScrolling = true
      this.boundingRect = event.detail.boundingRect
      this.waitUntilScrollingDone()
    },
    onEndPreviewScrolling() {
      this.isScrolling = false
      this.applyStyle(this.boundingRect)
    },
    applyStyle(boundingRect) {
      if (!boundingRect || !this.$el?.style) return // when we switch pages, the element is not mounted yet
      const self = this
      const newStyle = this.calculateStyle(boundingRect)
      Object.entries(newStyle).forEach(
        ([key, value]) => (self.$el.style[key] = value),
      )
    },
    calculateStyle(boundingRect) {
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
    hoveredSection: {
      handler(value) {
        if (!value) return

        this.isScrolling = false
        this.boundingRect = value.sectionRect
        this.applyStyle(value.sectionRect)
      }, 
      immediate: true
    }
  },
}
</script>