<template>
  <div>
    <input
      type="radio"
      name="selectedColor"
      :id="`${name}-custom`"
      :value="color"
      class="hidden"
      v-model="selectedColor"
    />
    <label
      :for="`${name}-custom`"
      :title="color"
      class="flex items-center cursor-pointer space-x-4"
      
    >
      <div
        class="w-10 h-10 rounded-sm transition transform duration-200 ease-in-out hover:scale-110 select-none rounded-sm text-white flex items-center justify-center"
        :style="{ 
          'background-color': realHexColor,
        }">
        <icon name="ri-check-line" size="1rem" v-if="color === selectedColor" />
      </div>

      <!-- <input type="text" v-model="selectedColor" /> -->
      <text-input v-model="selectedColor" :showLabel="false" />
    </label>
  </div>
</template>

<script>
import { hexToRgb } from '@/misc/utils'

export default {
  name: 'ColorInput',
  props: {
    name: { type: String, default: 'color' },
    value: { type: String },
  },
  data() {
    return { color: '#000000' }
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
  watch: {
    value: {
      immediate: true,
      handler(newValue) {
        if (newValue && !newValue.startsWith('--')) 
          this.color = newValue
      }
    }
  }
}
</script>
