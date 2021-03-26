<template>
  <dynamic-form 
    class="mt-2"
    :parentKey="currentSection.id"
    :settings="currentSectionDefinition.settings" 
    :content="sectionContent"
    :focusedSetting="settingId"
    @blur="onBlur"
    @change="updateSectionContent"
  />    
</template>

<script>
import { mapActions } from 'vuex'
import DynamicForm from '@/components/dynamic-form'

export default {
  name: 'SectionSettingList',
  components: { DynamicForm },
  props: {
    sectionId: { type: String, default: undefined },
    settingId: { type: String, default: undefined },
  },
  computed: {
    sectionContent() {
      return { ...this.currentSection?.settings }
    }
  },
  methods: {
    ...mapActions(['updateSectionContent']),
    onBlur() {
      this.$router.push({ name: 'editSection', params: { sectionId: this.sectionId } }).catch(err => {
        if (err.name !== 'NavigationDuplicated') throw(err);      
      })
    },
  },
}
</script>
