<template>
  <uikit-tabs
    :tabs="tabs"
    :firstIndex="tabIndexFromRoute"
    :otherProps="{ sectionId: currentSection.id, settingId }"
    class="overflow-y-hidden"
    navClass="px-4"
    panelClass="px-3"
    ref="tabs"
  />
</template>

<script>
import SettingList from './setting-list.vue'
import BlockList from './block-list/index.vue'
import BlockTree from './block-tree/index.vue'

export default {
  name: 'SectionPane',
  props: {
    settingId: { type: String, default: undefined },
  },
  computed: {
    unfilteredTabs() {
      return [
        {
          name: this.$t('sectionPane.tabs.settings'),
          tab: SettingList,
          type: 'content',
          condition: () => this.hasSettings,
        },
        {
          name: this.blocksLabel,
          tab: this.blocksComponent,
          type: 'blocks',
          condition: () => this.hasBlocks,
        },
        {
          name: this.$t('sectionPane.tabs.advanced'),
          tab: SettingList,
          type: 'advanced',
          condition: () => this.hasAdvancedSettings,
          props: () => ({ advanced: true }),
        },
      ]
    },
    tabs() {
      return this.unfilteredTabs.filter(
        (tab) => !tab.condition || tab.condition(),
      )
    },
    tabIndexFromRoute() {
      return this.findTabIndexFromRoute()
    },
    hasSettings() {
      return !this.isBlank(this.currentSectionSettings)
    },
    hasAdvancedSettings() {
      return !this.isBlank(this.currentSectionAdvancedSettings)
    },
    hasBlocks() {
      return !this.isBlank(this.currentSectionDefinition.blocks)
    },
    blocksLabel() {
      return (
        this.$st(`${this.currentSectionI18nScope}.blocks.label`) ||
        this.currentSectionDefinition.blocksLabel ||
        this.$t('sectionPane.tabs.blocks')
      )
    },
    blocksComponent() {
      return this.currentSectionDefinition.blocksPresentation === 'tree'
        ? BlockTree
        : BlockList
    },
  },
  methods: {
    findTabIndexFromRoute() {
      const type = this.$route.hash.replace('#', '')
      const index = this.tabs.findIndex((tab) => tab.type === type)
      return index === -1 ? 0 : index
    },
  },
  watch: {
    '$route.hash': {
      immediate: true,
      handler() {
        if (!this.$refs.tabs) return
        this.$refs.tabs.selectTab(this.findTabIndexFromRoute())
      },
    },
  },
}
</script>
