import Vue from 'vue'
import { mapState, mapActions } from 'vuex'
import { ModalBus } from '@/plugins/event-bus'
import services from '@/services'
import { isBlank } from '@/utils'

Vue.mixin({
  computed: {
    ...mapState(['device', 'previewReady']),
    services() {
      return services
    },
    currentSite() {
      return this.$store.state.site
    },
    currentLocale() {
      return this.$store.state.locale
    },
    currentPage() {
      return this.$store.state.page
    },
    isCurrentPageIndex() {
      return this.services.page.isIndex(this.currentPage)
    },
    currentTheme() {
      return this.$store.state.theme
    },
    currentSection() {
      return this.$store.state.section
    },
    currentSectionList() {
      return this.$store.getters.sectionList
    },
    currentSectionContent() {
      return this.$store.getters.sectionContent
    },
    currentSectionDefinition() {
      return this.$store.state.sectionDefinition
    },
    currentSectionSettings() {
      return this.$store.getters.sectionSettings(false)
    },
    currentSectionAdvancedSettings() {
      return this.$store.getters.sectionSettings(true)
    },
    currentSectionBlocks() {
      return this.$store.getters.sectionBlocks
    },
    currentSectionBlock() {
      return this.$store.state.sectionBlock
    },
    currentSectionBlockIndex() {
      return this.$store.getters.sectionBlockIndex
    },
    currentSectionBlockContent() {
      return this.$store.getters.sectionBlockContent
    },
    currentSectionBlockDefinition() {
      return this.$store.state.sectionBlockDefinition
    },
    currentSectionBlockSettings() {
      return this.$store.getters.sectionBlockSettings(false)
    },
    currentSectionBlockAdvancedSettings() {
      return this.$store.getters.sectionBlockSettings(true)
    },
    currentPageDefaultAttributes() {
      return this.$store.getters.defaultPageAttributes
    },
    currentContent() {
      return this.$store.getters.content
    },
    isDesktopDevice() {
      return this.device === 'desktop'
    },
    isMobileDevice() {
      return this.device === 'mobile'
    },
    isTabletDevice() {
      return this.device === 'tablet'
    },
    deviceWidthMap() {
      return {
        mobile: 375,
        tablet: 1024,
      }
    },
  },
  methods: {
    ...mapActions([
      'setDevice',
      'setLocale',
      'setPreviewDocument',
      'fetchSite',
      'fetchPage',
      'fetchSection',
      'fetchSectionBlock',
      'setCurrentPageSettings',
    ]),
    isBlank(value) {
      return isBlank(value)
    },
    openModal({ title, component, props, listeners, closeOnClick }) {
      ModalBus.$emit('open', {
        title,
        component,
        props,
        listeners,
        closeOnClick,
      })
    },
    closeModal() {
      ModalBus.$emit('close')
    },
  },
})
