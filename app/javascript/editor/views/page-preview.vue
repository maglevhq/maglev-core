<template>
  <div class="relative w-full h-full overflow-y-hidden">
    <div
      class="relative w-full h-full origin-top-left transition-all duration-100"
      :style="dynamicStyle"
    >
      <div
        class="flex h-full w-full justify-center items-center"
        :style="{ 'padding-left': `${loadingPaddingLeft}` }"
        v-if="!previewReady"
      >
        <p class="animate-bounce duration-200">
          {{ $t('pagePreview.loading') }}
        </p>
      </div>

      <div
        class="absolute inset-0 flex justify-center items-center"
        v-if="currentPage"
      >
        <div
          class="transition-all duration-100 ease-in-out"
          :class="{ [deviceClass]: true, hidden: isPageEmpty }"
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

        <div
          class="transition-all duration-100 ease-in-out"
          :style="{ opacity: previewReady ? 1 : 0 }"
          v-if="isPageEmpty && previewReady"
        >
          <h2
            class="text-center text-4xl font-bold"
            v-if="numberOfLocales === 1"
          >
            {{ $t('pagePreview.empty.title.withoutLocale') }}
          </h2>
          <i18n
            path="pagePreview.empty.title.withLocale"
            tag="h2"
            class="text-center text-2xl font-bold"
            v-else
          >
            <template v-slot:localeName>
              <span
                class="capitalize-first bg-editor-primary bg-opacity-20 px-2"
                >{{ currentLocaleName }}</span
              >
            </template>
          </i18n>

          <i18n
            path="pagePreview.empty.message"
            tag="div"
            class="flex mt-4 text-gray-600"
          >
            <template v-slot:icon>
              <icon name="add-box-line" size="1.5rem" class="mx-1 text-black" />
            </template>
          </i18n>
        </div>
      </div>
    </div>
    <section-highlighter :hovered-section="hoveredSection" />
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex'
import TransformationMixin from '@/mixins/preview-transformation'
import SectionHighlighter from '@/components/section-highlighter'

export default {
  name: 'PagePreview',
  components: { SectionHighlighter },
  mixins: [TransformationMixin],
  props: {
    locale: { type: String, default: null },
    pageId: { type: String, default: null },
  },
  data() {
    return { loadingPaddingLeft: 0, previewScrollTop: 0 }
  },
  mounted() {
    this.loadingPaddingLeft = `${this.calculatePreviewLeftPadding()}px`
  },
  computed: {
    ...mapState(['hoveredSection']),
    fullpath() {
      // TODO: why here? why not in the App.vue instead?
      return [this.locale, this.pageId]
    },
    isPageEmpty() {
      return this.currentSectionList.length === 0
    },
    numberOfLocales() {
      return this.currentSite.locales.length
    },
    currentLocaleName() {
      return this.currentSite.locales.find(
        (locale) => locale.prefix === this.currentLocale,
      ).label
    },
    deviceClass() {
      switch (this.device) {
        case 'mobile':
          return 'mobile'
        case 'tablet':
          return 'tablet'
        default:
          return 'desktop'
      }
    },
    dynamicStyle() {
      if (this.currentSection) {
        // not ideal to parse the DOM but we don't see any other methods for now
        let style = `transform: translateX(${this.previewLeftPadding}px) scale(${this.previewScaleRatio}); height: calc(100% * 1 / 1 / ${this.previewScaleRatio};`

        if (this.previewScaleRatio === 1)
          style += `width: ${this.previewPaneMaxWidth}px`

        return style
      } else return ''
    },
  },
  methods: {
    ...mapActions(['setPreviewDocument']),
    onIframeLoaded() {
      // console.log('ok 1')
      // const newUrl = new URL(
      //   this.$refs['iframe'].contentWindow.document.location.href,
      // )
      // console.log('ok 2')
      // if (this.currentPage.previewUrl !== newUrl.pathname) {
      //   this.setPreviewDocument(null)
      //   this.$refs['iframe'].src = this.currentPage.previewUrl
      //   return false
      // }
      // console.log('ok 3')
      // this.setPreviewDocument(this.$refs['iframe'].contentDocument)
    },
  },
  watch: {
    fullpath: {
      immediate: true,
      handler(newFullpath, oldFullpath) {
        const [newLocale, newPageId] = newFullpath
        const [oldLocale, oldPageId] = oldFullpath || []
        if ((newLocale !== oldLocale || newPageId !== oldPageId) && newPageId) {
          this.setLocale(newLocale)
          Promise.all([this.fetchPage(newPageId), this.fetchSite()])
        }
      },
    },
  },
}
</script>

<style scoped>
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
