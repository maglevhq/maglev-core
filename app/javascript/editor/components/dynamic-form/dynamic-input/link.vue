<template>
  <link-input
    :label="setting.label"
    :name="setting.id"
    :isFocused="isFocused"
    :withText="withText"
    v-model="inputValue"
  />
</template>

<script>
import DynamicInputMixin from '@/mixins/dynamic-input'

export default {
  name: 'DynamicLinkInput',
  mixins: [DynamicInputMixin],
  props: {
    withText() {
      return !!this.options.withText
    },
  },
}
</script>
