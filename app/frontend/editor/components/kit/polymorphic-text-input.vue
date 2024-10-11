<template>
  <div>
    <uikit-text-input
      :label="label"
      :name="name"
      :isFocused="isFocused"
      @blur="$emit('blur')"
      v-model="inputValue"
      v-if="isText"
    />
    <uikit-textarea-input
      :label="label"
      :name="name"
      :isFocused="isFocused"
      :rows="options.nbRows"
      @blur="$emit('blur')"
      v-model="inputValue"
      v-else-if="isTextArea"
    />
    <uikit-rich-text-input
      :label="label"
      :name="name"
      :isFocused="isFocused"
      :lineBreak="options.lineBreak"
      :rows="options.nbRows"
      :table="options.htmlTable"
      @blur="$emit('blur')"
      v-model="inputValue"
      v-else-if="isRichText"
    />
  </div>
</template>

<script>
export default {
  name: 'UIKitPolymorphicTextInput',
  props: {
    label: { type: String, default: 'Label' },
    name: { type: String, default: 'text' },
    value: { type: String },
    isFocused: { type: Boolean, default: false },
    options: { type: Object, default: {} }
  },
  computed: {
    isText() {
      return !this.options.html && parseInt(this.options.nbRows || 1) < 2
    },
    isTextArea() {
      return !this.options.html && parseInt(this.options.nbRows) > 1
    },
    isRichText() {
      return this.options.html
    },
    inputValue: {
      get() {
        return this.value
      },
      set(value) {
        this.$emit('input', value)
      },
    },
  },
}
</script>
