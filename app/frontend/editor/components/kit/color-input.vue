<template>
  <div class="space-y-2 pt-1">
    <label
      class="flex items-center justify-between font-semibold text-gray-800"
      :for="name"
      v-if="showLabel"
    >
      <span>{{ label }}</span>
      <core-input v-model="updatableValue" />
    </label>
    <div class="flex flex-wrap gap-1">
      <preset-button v-for="preset in presets" :preset="preset" v-model="updatableValue" :key="preset" />
    </div>
  </div>
</template>

<script>
import { hexToRgb } from '@/misc/utils'

import CoreInput from '@/components/kit/color-input/core-input.vue'
import PresetButton from '@/components/kit/color-input/preset-button.vue'

export default {
  name: 'ColorInput',
  components: { CoreInput, PresetButton },
  props: {
    label: { type: String, default: 'Label' },
    name: { type: String, default: 'color' },
    presets: {
      type: Array,
      default: () => [],
    },
    value: { type: String },
    showLabel: { type: Boolean, default: true }
  },
  computed: {
    updatableValue: {
      get() {
        return this.value
      },
      set(color) {
        this.$emit('input', color)
      },
    },
  },
}
</script>
