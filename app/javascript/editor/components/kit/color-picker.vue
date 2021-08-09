<template>
  <div>
    <label class="block font-semibold text-gray-800" :for="name">
      {{ label }}
    </label>
    <div class="flex gap-2 mt-2">
      <div v-for="preset in presets" :key="preset">
        <input
          type="radio"
          name="selectedColor"
          :id="`${name}-${preset}`"
          :value="preset"
          class="hidden"
          v-model="selectedColor"
        />
        <label
          :for="`${name}-${preset}`"
          :title="preset"
          class="
            inline-block
            w-9
            h-9
            mr-1
            cursor-pointer
            p-0.5
            border-4
            rounded-full
          "
          :style="{
            'border-color':
              preset === selectedColor ? selectedBorderColor : 'transparent',
          }"
        >
          <span
            class="
              block
              w-full
              h-full
              rounded-full
              transition
              transform
              duration-200
              ease-in-out
              hover:scale-110
              select-none
            "
            :style="`background-color: ${preset};`"
          >
          </span>
        </label>
      </div>
    </div>
  </div>
</template>

<script>
import { hexToRgb } from '@/utils'

export default {
  name: 'ColorPicker',
  props: {
    label: { type: String, default: 'Label' },
    name: { type: String, default: 'color' },
    presets: {
      type: Array,
      default: () => [],
    },
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
    selectedBorderColor() {
      const color = hexToRgb(this.selectedColor)
      return `rgba(${color.r}, ${color.g}, ${color.b}, 0.40)`
    },
  },
}
</script>
