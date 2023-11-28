<template>
  <div
    class="self-center cursor-pointer p-0.5 rounded-sm"
    @click="selectPreset"
  >
    <div
      class="flex items-center justify-center w-6 h-6 rounded-sm transition transform duration-200 ease-in-out hover:scale-110 select-none text-white"
      :class="{
        'border border-gray-300 text-gray-800': isWhite,
        'bg-checkerboard': isTransparent,
      }"
      :style="{ 'background-color': hexColor }"
    >
      <uikit-icon name="ri-check-line" size="1rem" v-if="selected" />
    </div>
  </div>
</template>

<script>
import { colorVariableToHex, colorVariableToRgb } from '@/misc/utils'

export default {
  name: 'PresetButton',
  props: {
    preset: { type: String },
    value: { type: String },
  },
  computed: {
    selected() {
      return !!this.value && this.value.trim().toLowerCase() === this.hexColor
    },
    hexColor() {
      return colorVariableToHex(this.preset)
    },
    rgbColor() {
      return colorVariableToRgb(this.preset)
    },
    isWhite() {
      if (!this.rgbColor) return true
      return (
        this.rgbColor.r === 255 &&
        this.rgbColor.g === 255 &&
        this.rgbColor.b === 255
      )
    },
    isTransparent() {
      return this.hexColor === ''
    },
    borderColor() {
      if (!this.selected) return 'transparent'
      let color = this.isWhite ? { r: 0, g: 0, b: 0 } : this.rgbColor
      return `rgba(${color.r}, ${color.g}, ${color.b}, 0.40)`
    },
  },
  methods: {
    selectPreset() {
      this.$emit('input', this.hexColor)
    },
  },
}
</script>
