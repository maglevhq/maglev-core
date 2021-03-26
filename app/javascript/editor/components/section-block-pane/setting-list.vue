<template>
  <dynamic-form 
    class="mt-2"
    :parentKey="currentSectionBlock.id"
    :settings="currentSectionBlockDefinition.settings" 
    :content="sectionBlockContent"
    :focusedSetting="settingId"
    @blur="onBlur"
    @change="updateSectionBlockContent"
  />    
</template>

<script>
import { mapActions } from 'vuex'
import DynamicForm from '@/components/dynamic-form'

export default {
  name: 'SectionBlockSettingList',
  components: { DynamicForm },
  props: {
    sectionBlockId: { type: String, default: undefined },
    settingId: { type: String, default: undefined },
  },
  computed: {
    sectionBlockContent() {
      return { ...this.currentSectionBlock?.settings }
    }
  },
  methods: {
    ...mapActions(['updateSectionBlockContent']),
    onBlur() {
      this.$router.push({ name: 'editSectionBlock', params: { sectionBlockId: this.sectionBlockId } }).catch(err => {
        if (err.name !== 'NavigationDuplicated') throw(err);      
      })
    },
  },
}
</script>
