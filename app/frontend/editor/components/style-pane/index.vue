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
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import DynamicForm from '@/components/dynamic-form/index.vue'

export default {
  name: 'StylePane',
  components: { DynamicForm },
  data() {
    return { style: [] }
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
    ...mapActions(['previewStyle']),
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
