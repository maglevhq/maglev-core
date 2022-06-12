<template>
  <div class="flex flex-col h-full overflow-hidden">
    <div class="flex-1 overflow-y-scroll">
      <dynamic-form
        parentKey="style"
        :settings="styleSettings"
        :content="style"
        @change="onChange"
      />
    </div>
    <div class="mt-auto">
      <submit-button
        type="button"
        class="big-submit-button"
        defaultColorClass="bg-editor-primary"
        :labels="$t('style.edit.submitButton')"
        :buttonState="submitState"
        @click="updateStyle"
      >
        {{ $t('style.edit.submitButton') }}
      </submit-button>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import DynamicForm from '@/components/dynamic-form'

export default {
  name: 'StylePane',
  components: { DynamicForm },
  data() {
    return { submitState: 'default', style: [] }
  },
  mounted() {
    this.style = this.currentStyle
  },
  beforeDestroy() {
    this.previewStyle(this.currentStyle)
  },
  computed: {
    styleSettings() {
      return this.currentTheme.styleSettings
    },
  },
  methods: {
    ...mapActions(['previewStyle', 'setStyle']),
    updateStyle() {
      this.submitState = 'inProgress'
      this.services.site
        .updateStyle(this.style)
        .then(() => {
          this.submitState = 'success'
          this.setStyle(this.style)
        })
        .catch(() => (this.submitState = 'fail'))
    },
    onChange(change) {
      this.style = this.style.map((value) => {
        const newValue = { ...value }
        if (value.id === change.settingId) newValue.value = change.value
        return newValue
      })
      this.previewStyle(this.style)
    },
  },
}
</script>
