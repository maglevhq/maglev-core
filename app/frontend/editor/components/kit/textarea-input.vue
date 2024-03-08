<template>
  <div class="space-y-1 flex flex-col">
    <label
      :for="name"
      class="block font-semibold text-gray-800 flex justify-between items-center"
    >
      <span>{{ label }}</span>
      <span
        v-if="maxLength"
        class="text-xs"
        :class="{
          'text-red-600': isOverMaxLength,
          'text-gray-600': !isOverMaxLength,
        }"
        >{{ numCharacters }} / {{ maxLength }}</span
      >
    </label>
    <textarea
      :id="name"
      :value="value"
      @blur="blur()"
      @input="updateInput"
      class="block mt-1 py-2 px-3 rounded bg-gray-100 text-gray-800 focus:outline-none focus:ring"
      autocomplete="off"
      ref="input"
      :rows="rows"
    />
  </div>
</template>

<script>
import FocusedInputMixin from '@/mixins/focused-input'

export default {
  name: 'UIKitTextInput',
  mixins: [FocusedInputMixin],
  props: {
    label: { type: String, default: 'Label' },
    name: { type: String, default: 'text' },
    value: { type: String },
    maxLength: { type: Number, default: null },
    rows: { type: Number, default: 2 },
  },
  computed: {
    numCharacters() {
      return (this.value || '').length
    },
    isOverMaxLength() {
      return this.numCharacters > this.maxLength
    },
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
