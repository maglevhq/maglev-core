import { vueWindowSizeMixin } from 'vue-window-size'

export default {
  mixins: [vueWindowSizeMixin],
  computed: {
    previewLeftPadding() {
      return this.currentSection ? this.calculatePreviewLeftPadding() : 0
    },
    previewScaleRatio() {
      if (!this.currentSection) return 1
      const sidebarWidth = document.querySelector('.content-area > aside').offsetWidth
      const sectionPaneWidth = document.querySelector('.slide-pane').offsetWidth
      return (this.windowWidth - sectionPaneWidth) / (this.windowWidth - sidebarWidth)
    }
  },
  methods: {
    calculatePreviewLeftPadding() {
      const sidebarWidth = document.querySelector('.content-area > aside')?.offsetWidth || 0    
      const sectionPaneWidth = document.querySelector('.slide-pane')?.offsetWidth || 0    
      return sectionPaneWidth - sidebarWidth
    }
  } 
}