<template>
  <tabs 
    :tabs="tabs" 
    :firstIndex="tabIndexFromRoute"
    :otherProps="{ sectionId: currentSection.id, settingId }"
    sharedClass="px-4"
  />        
</template>

<script>
import SettingList from './setting-list'
import BlockList from './block-list'
import AdvancedForm from './advanced-form'

export default {
  name: 'SectionPane',
  components: { SettingList, BlockList, AdvancedForm },
  props: {
    settingId: { type: String, default: undefined },
  },
  computed: {    
    unfilteredTabs() {
      return [
        { 
          name: this.$t('sectionPane.tabs.settings'), tab: SettingList, type: 'settings' },
        { 
          name: this.$t('sectionPane.tabs.blocks'), 
          tab: BlockList, 
          type: 'blocks', 
          condition: () => !this.isBlank(this.currentSectionDefinition.blocks)
        },
        { name: this.$t('sectionPane.tabs.advanced'), tab: AdvancedForm, type: 'advanced' },
      ]
    },
    tabs() {
      return this.unfilteredTabs.filter(tab => !tab.condition || tab.condition())
    },
    tabIndexFromRoute() {
      const type = this.$route.hash.replace('#', '')
      const index = this.tabs.findIndex(tab => tab.type === type)
      return index === -1 ? 0 : index
    },    
  },    
}
</script>
