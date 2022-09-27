<template>
  <div class="flex flex-col h-full overflow-hidden">
    <div class="flex-1 overflow-y-scroll px-4">
      <dynamic-form
        parentKey="style"
        :settings="styleSettings"
        :content="style"
        @change="onChange"
      />
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
    return { style: [] }
  },
  mounted() {
    this.style = this.currentStyle
  },
  computed: {
    styleSettings() {
      return this.currentTheme.styleSettings
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
