import Vue from 'vue'
import { mapState, mapActions } from 'vuex'
import { ModalBus } from '@/plugins/event-bus'
import services from '@/services'
import { isBlank } from '@/misc/utils'

Vue.mixin({
  computed: {
    ...mapState(['device', 'previewReady']),
    services() {
      return services
    },
    isSitePublishable() {
      return this.$store.state.editorSettings.sitePublishable
    },
    currentSite() {
      return this.$store.state.site
    },
    currentI18nScope() {
      return `themes.${this.currentTheme.id}`
    },
    currentStyle() {
      return this.$store.state.style
    },
    currentStyleI18nScope() {
      return `${this.currentI18nScope}.style`
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
    currentSectionI18nScope() {
      return `${this.currentI18nScope}.sections.${this.currentSection.type}`
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
    currentSectionBlockI18nScope() {
      return `${this.currentSectionI18nScope}.blocks.${this.currentSectionBlock.type}`
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
    hasMultipleLocales() {
      return this.$store.state.site.locales.length > 1
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
    $st(key) {
      // console.log('$st', key, this.$te(key) ? this.$t(key) : null)
      return this.$te(key) ? this.$t(key) : null
    },
  },
})
