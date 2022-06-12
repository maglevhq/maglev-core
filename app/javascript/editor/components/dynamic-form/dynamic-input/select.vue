<template>
  <simple-select
    :label="setting.label"
    :name="setting.id"
    v-model="inputValue"
    :selectOptions="options.selectOptions"
  />
</template>

<script>
import DynamicInputMixin from '@/mixins/dynamic-input'

export default {
  name: 'DynamicSelectInput',
  mixins: [DynamicInputMixin],
}
</script>
