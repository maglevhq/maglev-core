<template>
  <tabs 
    :tabs="tabs" 
    :firstIndex="tabIndexFromRoute"
    :otherProps="{ sectionBlockId: currentSectionBlock.id, settingId }"
    sharedClass="px-4"
  />        
</template>

<script>
import SettingList from './setting-list'
import AdvancedForm from './advanced-form'

export default {
  name: 'SectionBlockPane',
  components: { SettingList, AdvancedForm },
  props: {
    settingId: { type: String, default: undefined },
  },
  computed: {    
    unfilteredTabs() {
      return [
        { 
          name: this.$t('sectionBlockPane.tabs.settings'), tab: SettingList, type: 'settings' },
        { name: this.$t('sectionBlockPane.tabs.advanced'), tab: AdvancedForm, type: 'advanced' },
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
