<template>
  <div class="space-y-1 flex flex-col">
    <label
      class="block font-semibold text-gray-800"
      :for="name"
      v-if="showLabel"
    >
      <span>{{ label }}</span>
      <transition name="fade">
        <span
          class="text-red-700 bg-red-100 text-xs ml-4 py-1 px-3 rounded"
          v-if="showError"
          >{{ error[0] }}
        </span>
      </transition>
    </label>
    <input
      :id="name"
      type="text"
      :value="value"
      :placeholder="placeholder"
      @blur="blur()"
      @input="updateInput"
      class="block py-2 px-3 rounded bg-gray-100 text-gray-800 focus:outline-none focus:ring placeholder-gray-500"
      autocomplete="off"
      ref="input"
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
    placeholder: { type: String, default: null },
    showLabel: { type: Boolean, default: true },
    error: { type: Array, default: null },
  },
  data() {
    return { showError: false }
  },
  methods: {
    updateInput(event) {
      this.showError = false
      this.$emit('input', event.target.value)
    },
    focus() {
      this.$refs.input.focus()
    },
  },
  watch: {
    error() {
      if (!this.isBlank(this.error)) this.showError = true
    },
  },
}
</script>
