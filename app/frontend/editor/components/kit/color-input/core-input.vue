<template>
  <div class="relative">
    <div 
      class="absolute left-3 top-2 w-6 h-6 rounded-sm border border-gray-200" 
      :class="{ 'bg-checkerboard': isTransparent }"
      :style="{ 'background-color': styleRgbaColor }"></div>

    <span class="absolute left-11 top-1.5 font-bold text-gray-900 text-lg">#</span>

    <input
      type="text"
      :value="inputColor"
      @input="updateInput"
      class="py-2 pl-14 pr-3 rounded bg-gray-100 text-gray-800 focus:outline-none focus:ring placeholder-gray-500 font-normal"
      autocomplete="off"
      minlength="4" 
      maxlength="8"
      size="7"
    />
  </div>
</template>

<script>
import { colorVariableToHex, colorVariableToRgb } from '@/misc/utils'

export default {
  name: 'CoreInput',
  props: {
    value: { type: String },
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
      const color = this.isTransparent ? { r: 255, g: 255, b: 255 } : (this.rgbColor || { r: 0, g: 0, b: 0 })
      return `rgba(${color.r}, ${color.g}, ${color.b}, 1)`
    },
    isTransparent() {
      return this.value === ''
    },
  },
  methods: {
    updateInput(event) {
      this.$emit('input', event.target.value)
    }
  }
}
</script>
