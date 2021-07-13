<template>
  <div>
    <label class="block font-semibold text-gray-800" :for="name">
      {{ label }}
    </label>
    <textarea
      :id="name"
      :value="value"
      @blur="blur()"
      @input="updateInput"
      class="
        block
        w-full
        mt-1
        py-2
        px-3
        rounded
        bg-gray-100
        text-gray-800
        focus:outline-none focus:ring
      "
      autocomplete="off"
      ref="input"
    />
  </div>
</template>

<script>
import FocusedInputMixin from '@/mixins/focused-input'

export default {
  name: 'TextInput',
  mixins: [FocusedInputMixin],
  props: {
    label: { type: String, default: 'Label' },
    name: { type: String, default: 'text' },
    value: { type: String },
  },
  methods: {
    updateInput(event) {
      this.$emit('input', event.target.value)
    },
    focus() {
      this.$refs.input.focus()
    },
  },
}
</script>
