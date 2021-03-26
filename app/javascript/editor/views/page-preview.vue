<template>
  <div class="relative w-full h-full overflow-y-hidden">
    <div 
      class="relative w-full h-full origin-top-left transition-transform duration-200"
      :style="dynamicStyle"    
    >
      <div 
        class="flex h-full w-full justify-center items-center" 
        :style="{ 'padding-left': `${loadingPaddingLeft}`}"
        v-if="!previewReady"
      >
        <p class="animate-bounce duration-200">{{ $t('pagePreview.loading') }}</p>
      </div>
      <div class="absolute inset-0 flex justify-center" v-if="currentPage">
        <div 
          class="device transition-opacity duration-200 ease-in-out"
          :class="deviceClass"
          :style="{ opacity: previewReady ? 1 : 0 }" 
        >
          <iframe 
            class="w-full h-full"                     
            :src="currentPage.previewUrl" 
            @load="onIframeLoaded"
            ref="iframe"
          >        
          </iframe>
        </div>
      </div>
    </div>
    <section-highlighter :hovered-section="hoveredSection" /> 
  </div>
</template>

<script>
import { mapState } from 'vuex'
import TransformationMixin from '@/mixins/preview-transformation'
import SectionHighlighter from '@/components/section-highlighter'

export default {
  name: 'PagePreview',
  components: { SectionHighlighter },
  mixins: [TransformationMixin],
  props: {
    pageId: { type: String, default: null }
  }, 
  data() { 
    return { loadingPaddingLeft: 0, previewScrollTop: 0 }
  },
  mounted() {
    this.loadingPaddingLeft = `${this.calculatePreviewLeftPadding()}px`    
  },  
  computed: {  
    ...mapState(['hoveredSection']),
    deviceClass() {
      switch (this.device) {
        case 'mobile': return 'mobile'
        case 'tablet': return 'tablet'
        default:
          return 'desktop'
      }
    },
    dynamicStyle() {
      if (this.currentSection) {
        // not ideal to parse the DOM but we don't see any other methods for now
        return `transform: translateX(${this.previewLeftPadding}px) scale(${this.previewScaleRatio}); height: calc(100% * 1 / 1 / ${this.previewScaleRatio}`
      } else
        return ''
    },    
  },
  methods: {
    onIframeLoaded() {
      this.setPreviewDocument(this.$refs['iframe'].contentDocument)      
    },    
  },
  watch: {
    pageId: {
      immediate: true,
      handler(newPageId, oldPageId) {
        if (newPageId !== oldPageId && newPageId) {
          setTimeout(() => this.fetchPage(newPageId), 1000)          
        }
      }
    },    
  }
}
</script>

<style scoped>
.device {
  transition: all 800ms ease-out;
}

.mobile {
  width: 375px;
  height: 100%;
  /* max-height: 667px;   */
}

.tablet {
  width: 1024px;
  height: 100%;
  /* max-height: 1366px;   */
}

.desktop {
  width: 100%;
  height: 100%;
}
</style>
