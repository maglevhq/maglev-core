<template>
  <icon-input
    :label="setting.label"
    :name="setting.id"
    :isFocused="isFocused"
    v-model="inputValue"
  />
</template>

<script>
import DynamicInputMixin from '@/mixins/dynamic-input'

export default {
  name: 'DynamicIconInput',
  mixins: [DynamicInputMixin],
}
</script>
