<template>
  <dynamic-form
    class="mt-2"
    :parentKey="currentSection.id"
    :settings="sectionSettings"
    :content="currentSectionContent"
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
    advanced: { type: Boolean, default: false },
  },
  computed: {
    sectionSettings() {
      return this.advanced
        ? this.currentSectionAdvancedSettings
        : this.services.section.filterSettings(
            this.currentSectionSettings,
            this.currentSectionContent,
          )
    },
  },
  methods: {
    ...mapActions(['updateSectionContent']),
    onBlur() {
      this.$router
        .push({ name: 'editSection', params: { sectionId: this.sectionId } })
        .catch((err) => {
          if (err.name !== 'NavigationDuplicated') throw err
        })
    },
  },
}
</script>
