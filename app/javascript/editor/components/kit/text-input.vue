<template>
  <div>
    <label class="block font-bold text-gray-800" :for="name" v-if="showLabel">
      {{ label }}
    </label>
    <input 
      :id="name"
      type="text" 
      :value="value"
      :placeholder="placeholder"
      @blur="blur()"
      @input="updateInput" 
      class="block w-full mt-1 py-2 px-3 rounded bg-gray-100 text-gray-800 focus:outline-none focus:shadow-outline placeholder-gray-500"       
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
    placeholder: { type: String, default: null },
    showLabel: { type: Boolean, default: true },
  },  
  methods: {
    updateInput(event) {
      this.$emit('input', event.target.value)
    },
    focus() {
      this.$refs.input.focus()      
    }
  },  
}
</script>
