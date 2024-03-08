<template>
  <div class="pt-1">
    <label
      class="flex items-center justify-between font-semibold text-gray-800"
      :for="name"
      v-if="showLabel"
    >
      <span class="pr-2">{{ label }}</span>
      <core-input :name="name" :presets="presets" v-model="updatableValue" />
    </label>
  </div>
</template>

<script>
import CoreInput from '@/components/kit/color-input/core-input.vue'

export default {
  name: 'UIKitColorInput',
  components: { CoreInput },
  props: {
    label: { type: String, default: 'Label' },
    name: { type: String, default: 'color' },
    presets: {
      type: Array,
      default: () => [],
    },
    value: { type: String },
    showLabel: { type: Boolean, default: true },
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
