<template>
  <dynamic-form
    class="mt-2"
    :parentKey="currentSectionBlock.id"
    :settings="sectionBlockSettings"
    :content="currentSectionBlockContent"
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
    advanced: { type: Boolean, default: false },
  },
  computed: {
    sectionBlockSettings() {
      return this.advanced
        ? this.currentSectionBlockAdvancedSettings
        : this.currentSectionBlockSettings
    },
  },
  methods: {
    ...mapActions(['updateSectionBlockContent']),
    onBlur() {
      this.$router
        .push({
          name: 'editSectionBlock',
          params: { sectionBlockId: this.sectionBlockId },
        })
        .catch(err => {
          if (err.name !== 'NavigationDuplicated') throw err
        })
    },
  },
}
</script>
