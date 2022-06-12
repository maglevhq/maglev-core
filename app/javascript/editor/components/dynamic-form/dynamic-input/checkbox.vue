<template>
  <checkbox-input
    :label="setting.label"
    :name="setting.id"
    v-model="inputValue"
  />
</template>

<script>
import DynamicInputMixin from '@/mixins/dynamic-input'

export default {
  name: 'DynamicCheckboxInput',
  mixins: [DynamicInputMixin],
}
</script>
