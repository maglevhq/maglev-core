<template>
  <div>
    <input
      type="radio"
      name="selectedColor"
      :id="`${name}-${color}`"
      :value="realHexColor"
      class="hidden"
      v-model="selectedColor"
    />
    <label
      :for="`${name}-${color}`"
      :title="color"
      class="block  cursor-pointer p-0.5 border-4 rounded-sm"
      :style="{
        'border-color':
          realHexColor === selectedColor ? selectedBorderColor : 'transparent',
      }"
    >
      <div
        class="flex items-center justify-center w-6 h-6 rounded-sm transition transform duration-200 ease-in-out hover:scale-110 select-none text-white"
        :class="{ 'border border-gray-300': isWhite }"
        :style="{ 'background-color': realHexColor }"
      >
        <icon name="ri-check-line" size="1rem" v-if="realHexColor === selectedColor" />
      </div>
    </label>
  </div>
</template>

<script>
import { hexToRgb } from '@/misc/utils'

export default {
  name: 'ColorButton',
  props: {
    name: { type: String, default: 'color' },
    color: { type: String },
    value: { type: String },
  },
  computed: {
    selectedColor: {
      get() {
        return this.value
      },
      set(color) {
        this.$emit('input', color)
      },
    },
    realHexColor() {
      return this.color.startsWith('--')
        ? getComputedStyle(document.body).getPropertyValue(this.color)
        : this.color
    },
    rgbColor() {
      return hexToRgb(this.realHexColor)
    },
    isWhite() {
      if (!this.rgbColor) return true
      return this.rgbColor.r === 255 && this.rgbColor.g === 255 && this.rgbColor.b === 255
    },
    selectedBorderColor() {
      let color = this.isWhite ? { r: 0, g: 0, b: 0 } : this.rgbColor
      return `rgba(${color.r}, ${color.g}, ${color.b}, 0.40)`
    }
  },
}
</script>
