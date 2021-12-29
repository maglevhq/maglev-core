<template>
  <color-picker
    :label="setting.label"
    :name="setting.id"
    v-model="inputValue"
    :presets="options.presets"
  />
</template>

<script>
import DynamicInputMixin from '@/mixins/dynamic-input'

export default {
  name: 'DynamicColorInput',
  mixins: [DynamicInputMixin],
}
</script>
