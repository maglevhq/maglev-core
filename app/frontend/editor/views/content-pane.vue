<template>
  <layout
    :title="title"
    :overflowY="false"
    :max-width-pane="isMaxWidthPane"
    :with-pre-title="isSectionBlockVersion"
  >
    <template v-slot:pre-title v-if="isSectionBlockReady">
      <p class="text-gray-600 hover:text-gray-900">
        <router-link
          :to="{
            name: 'editSection',
            params: { sectionId: currentSection.id },
            hash: '#blocks',
          }"
          class="flex items-center"
        >
          <uikit-icon name="arrow-drop-left" />
          <span class="text-xs">{{ sectionTitle }}</span>
        </router-link>
      </p>
    </template>

    <section-pane :settingId="settingId" v-if="isSectionReady" />
    <section-block-pane :settingId="settingId" v-if="isSectionBlockReady" />

    <div
      class="mt-4 mx-4 text-lg rounded h-64 bg-gray-200 animate-pulse"
      v-if="!isSectionReady && !isSectionBlockReady"
    >
      &nbsp;
    </div>
  </layout>
</template>

<script>
import Layout from '@/layouts/slide-pane.vue'
import SectionPane from '@/components/section-pane/index.vue'
import SectionBlockPane from '@/components/section-block-pane/index.vue'

export default {
  name: 'ContentPane',
  components: { Layout, SectionPane, SectionBlockPane },
  props: {
    sectionId: { type: String, default: undefined },
    sectionBlockId: { type: String, default: undefined },
    settingId: { type: String, default: undefined },
  },
  computed: {
    title() {
      if (this.isSectionReady) return this.sectionTitle
      else if (this.isSectionBlockReady) return this.sectionBlockTitle
      else return null
    },
    sectionTitle() {
      return (
        this.$st(`${this.currentSectionI18nScope}.name`) ||
        this.currentSectionDefinition?.name
      )
    },
    sectionBlockTitle() {
      return (
        this.$st(`${this.currentSectionI18nScope}.blocks.label`) ||
        this.currentSectionBlockDefinition?.name +
          ' ' +
          `#${this.currentSectionBlockIndex}`
      )
    },
    isSectionReady() {
      return this.sectionId && this.currentSection
    },
    isSectionBlockVersion() {
      return !!this.sectionBlockId
    },
    isSectionBlockReady() {
      return this.isSectionBlockVersion && this.currentSectionBlock
    },
    isMaxWidthPane() {
      return !!this.currentSectionDefinition?.maxWidthPane
    },
    reactiveKey() {
      return [!!this.currentPage, !!this.previewReady, this.$route.path].join(
        '-',
      )
    },
  },
  destroyed() {
    this.fetchSection(null)
  },
  methods: {
    async fetch() {
      if (this.sectionBlockId) await this.fetchSectionBlock(this.sectionBlockId)
      else if (this.sectionId) await this.fetchSection(this.sectionId)

      if (!this.currentSection && !this.currentSectionBlock)
        this.$router.push({ name: 'editPage' })
    },
  },
  watch: {
    reactiveKey: {
      immediate: true,
      handler() {
        if (!this.currentPage || !this.previewReady) return // wait for the page to be loaded
        this.fetch()
      },
    },
  },
}
</script>
