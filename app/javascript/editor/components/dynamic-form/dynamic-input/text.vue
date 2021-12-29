<template>
  <div>
    <text-input
      :label="setting.label"
      :name="setting.id"
      :isFocused="isFocused"
      @blur="$emit('blur')"
      v-model="inputValue"
      v-if="isSimpleText"
    />
    <textarea-input
      :label="setting.label"
      :name="setting.id"
      :isFocused="isFocused"
      :rows="options.nbRows"
      @blur="$emit('blur')"
      v-model="inputValue"
      v-if="isTextarea"
    />
    <rich-text-input
      :label="setting.label"
      :name="setting.id"
      :isFocused="isFocused"
      :lineBreak="options.lineBreak"
      :rows="options.nbRows"
      @blur="$emit('blur')"
      v-model="inputValue"
      v-if="isRichText"
    />
  </div>
</template>

<script>
import DynamicInputMixin from '@/mixins/dynamic-input'

export default {
  name: 'DynamicTextInput',
  mixins: [DynamicInputMixin],
  computed: {
    isSimpleText() {
      return !this.isRichText && this.numberOfRows < 2
    },
    isTextarea() {
      return !this.isRichText && this.numberOfRows > 1
    },
    isRichText() {
      return !!this.options.html
    },
    numberOfRows() {
      return parseInt(this.options.nbRows || 1)
    },
  },
}
</script>
