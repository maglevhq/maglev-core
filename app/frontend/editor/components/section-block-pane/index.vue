<template>
  <uikit-tabs
    :tabs="tabs"
    :firstIndex="tabIndexFromRoute"
    :otherProps="{ sectionBlockId: currentSectionBlock.id, settingId }"
    sharedClass="px-4"
    ref="tabs"
  />
</template>

<script>
import SettingList from './setting-list.vue'

export default {
  name: 'SectionBlockPane',
  props: {
    settingId: { type: String, default: undefined },
  },
  computed: {
    unfilteredTabs() {
      return [
        {
          name: this.$t('sectionBlockPane.tabs.settings'),
          tab: SettingList,
          type: 'content',
          condition: () => this.hasSettings,
        },
        {
          name: this.$t('sectionBlockPane.tabs.advanced'),
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
      return !this.isBlank(this.currentSectionBlockSettings)
    },
    hasAdvancedSettings() {
      return !this.isBlank(this.currentSectionBlockAdvancedSettings)
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
