<template>
  <div class="mt-2 space-y-6">
    <uikit-mirror-section-input 
      :section="currentSection"
      v-model="mirrorOf" 
      v-if="mirrorFeature"
    />
    
    <dynamic-form
      :parentKey="currentSection.id"
      :settings="sectionSettings"
      :content="currentSectionContent"
      :focusedSetting="settingId"
      :i18nScope="i18nScope"
      @blur="onBlur"
      @change="updateSectionContent"
    />
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import DynamicForm from '@/components/dynamic-form/index.vue'

export default {
  name: 'SectionSettingList',
  components: { DynamicForm },
  props: {
    sectionId: { type: String, default: undefined },
    settingId: { type: String, default: undefined },
    advanced: { type: Boolean, default: false },
    mirrorFeature: { type: Boolean, default: false }
  },
  data() {
    return { mirrorOf: { enabled: false } }
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
    i18nScope() {
      return `${this.currentSectionI18nScope}.settings`
    },
  },
  methods: {
    ...mapActions(['updateSectionContent', 'mirrorSectionContent']),
    onBlur() {
      this.$router
        .push({ name: 'editSection', params: { sectionId: this.sectionId } })
        .catch((err) => {
          if (err.name !== 'NavigationDuplicated') throw err
        })
    },
  },
  change: {
    mirrorOf(newValue, oldValue) {
      console.log('SettingList', 'mirrorOf 🪩', newValue)
      // this.mirrorSectionContent({
      //   enabled,
      //   source,
      //   target: {
      //     layoutGroupId: this.currentSectionLayoutGroupIdMap[this.sectionId],
      //     sectionId: this.sectionId
      //   }
      // })
    }
  }
}
</script>
