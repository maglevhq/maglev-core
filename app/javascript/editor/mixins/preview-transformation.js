import { vueWindowSizeMixin } from 'vue-window-size'

export default {
  mixins: [vueWindowSizeMixin],
  computed: {
    previewLeftPadding() {
      return this.currentSection ? this.calculatePreviewLeftPadding() : 0
    },
    previewPaneMaxWidth() {
      const sectionPaneWidth =
        document.querySelector('.slide-pane')?.offsetWidth || 0
      return this.windowWidth - sectionPaneWidth
    },
    previewScaleRatio() {
      if (!this.mustPreviewScale()) return 1
      const sidebarWidth = document.querySelector(
        '.content-area > aside',
      ).offsetWidth
      const sectionPaneWidth = document.querySelector('.slide-pane').offsetWidth
      return (
        (this.windowWidth - sectionPaneWidth) /
        (this.windowWidth - sidebarWidth)
      )
    },
    hasEnoughWidthForTablet() {
      return (
        this.isTabletDevice &&
        this.previewPaneMaxWidth > this.deviceWidthMap.tablet
      )
    },
    hasEnoughWidthForMobile() {
      return (
        this.isMobileDevice &&
        this.previewPaneMaxWidth > this.deviceWidthMap.mobile
      )
    },
  },
  methods: {
    calculatePreviewLeftPadding() {
      const sidebarWidth =
        document.querySelector('.content-area > aside')?.offsetWidth || 0
      const sectionPaneWidth =
        document.querySelector('.slide-pane')?.offsetWidth || 0
      return sectionPaneWidth - sidebarWidth
    },
    mustPreviewScale() {
      // case: the section / block pane is not opened
      if (!this.currentSection) return false

      // case: there is enough width for the tablet viewport, no need to scale down
      if (this.hasEnoughWidthForTablet) return false

      // case: there is enough width for the mobile viewport, no need to scale down
      if (this.hasEnoughWidthForMobile) return false

      return true // desktop device
    },
  },
}
