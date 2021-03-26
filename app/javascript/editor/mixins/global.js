import Vue from 'vue'
import { mapState, mapActions } from 'vuex'
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
    currentPage() {
      return this.$store.state.page
    },
    currentTheme() {
      return this.$store.state.theme
    },
    currentSection() {
      return this.$store.state.section
    },
    currentSectionDefinition() {
      return this.$store.state.sectionDefinition
    },
    currentSectionBlocks() {
      return this.$store.getters.sectionBlocks
    },
    currentSectionBlock() {
      return this.$store.state.sectionBlock
    },
    currentSectionBlockDefinition() {
      return this.$store.state.sectionBlockDefinition
    },
    currentContent() {
      return this.$store.getters.content
    },
  },
  methods: {
    ...mapActions(['setDevice', 'setPreviewDocument', 'fetchPage', 'fetchSection', 'fetchSectionBlock']),
    isBlank(value) {
      return isBlank(value)
    }
  }
})