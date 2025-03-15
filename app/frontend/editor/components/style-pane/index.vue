<template>
  <div class="flex flex-col h-full overflow-hidden">
    <div class="flex-1 overflow-y-scroll px-4">
      <dynamic-form
        parentKey="style"
        :settings="styleSettings"
        :content="style"
        :i18nScope="i18nScope"
        @change="onChange"
      />
    </div>
    <div class="mt-auto px-4 pt-4">
      <uikit-submit-button
        type="button"
        class="big-submit-button"
        defaultColorClass="bg-editor-primary"
        :labels="$t('style.edit.submitButton')"
        :buttonState="submitState"
        @click="updatePage"
      >
      {{ $t('style.edit.submitButton') }}
      </uikit-submit-button>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import DynamicForm from '@/components/dynamic-form/index.vue'

export default {
  name: 'StylePane',
  components: { DynamicForm },
  data() {
    return { style: [], submitState: 'default' }
  },
  mounted() {
    this.style = this.currentStyle
  },
  computed: {
    styleSettings() {
      return this.currentTheme.styleSettings
    },
    i18nScope() {
      return `${this.currentStyleI18nScope}.settings`
    },
  },
  methods: {
    ...mapActions(['previewStyle', 'updateSite']),
    onChange(change) {
      this.style = this.style.map((value) => {
        const newValue = { ...value }
        if (value.id === change.settingId) newValue.value = change.value
        return newValue
      })
      this.previewStyle(this.style)
    },
    updatePage() {
      this.submitState = 'inProgress'
      this.services.site
      .updateStyle(this.style)
      .then(() => this.submitState = 'success')
      .catch(() => this.submitState = 'fail')
    }
  },
}
</script>
