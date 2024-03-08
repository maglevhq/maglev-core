<template>
  <div class="relative">
    <div
      class="absolute left-3 top-2 w-6 h-6 rounded-sm border border-gray-200"
      :class="{ 'bg-checkerboard': isTransparent }"
      :style="{ 'background-color': styleRgbaColor }"
    ></div>

    <span class="absolute left-11 top-1.5 font-bold text-gray-900 text-lg"
      >#</span
    >

    <input
      :id="name"
      type="text"
      :value="inputColor"
      @input="updateInput"
      class="py-2 pl-14 rounded bg-gray-100 text-gray-800 focus:outline-none focus:ring placeholder-gray-500 font-normal"
      :class="{
        'pr-8': hasPresets,
        'pr-2': !hasPresets,
      }"
      autocomplete="off"
      minlength="4"
      maxlength="8"
      size="7"
    />

    <preset-dropdown
      v-model="updatableValue"
      :presets="presets"
      v-if="hasPresets"
    />
  </div>
</template>

<script>
import PresetDropdown from './preset-dropdown.vue'

import { colorVariableToHex, colorVariableToRgb } from '@/misc/utils'

export default {
  name: 'CoreInput',
  components: { PresetDropdown },
  props: {
    name: { type: String, default: 'color' },
    value: { type: String },
    presets: {
      type: Array,
      default: () => [],
    },
  },
  computed: {
    inputColor() {
      return this.hexColor?.replaceAll('#', '')
    },
    hexColor() {
      return colorVariableToHex(this.value)
    },
    rgbColor() {
      return colorVariableToRgb(this.value)
    },
    styleRgbaColor() {
      const color = this.isTransparent
        ? { r: 255, g: 255, b: 255 }
        : this.rgbColor || { r: 0, g: 0, b: 0 }
      return `rgba(${color.r}, ${color.g}, ${color.b}, 1)`
    },
    isTransparent() {
      return this.value === ''
    },
    hasPresets() {
      return this.presets && this.presets.length > 0
    },
    updatableValue: {
      get() {
        return this.value
      },
      set(color) {
        this.$emit('input', color)
      },
    },
  },
  methods: {
    updateInput(event) {
      var value = event.target.value.replace('#', '')
      if (value.length > 0) value = `#${value}`
      this.$emit('input', value)
    },
  },
}
</script>
