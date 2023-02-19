<template>
  <div>TODO: color picker</div>
  <!-- <div>
    <label class="block font-semibold text-gray-800" :for="name">
      {{ label }}
    </label>
    <div class="flex flex-wrap gap-0.5 mt-2">
      <color-input :name="name" v-model="selectedColor" key="custom-color" class="w-full" />
      <color-button v-for="preset in presets" :name="name" :color="preset" v-model="selectedColor" :key="preset" />
    </div>
  </div> -->
</template>

<script>
  export default {
    name: 'ColorPicker'
  }
// import ColorButton from '@/components/color-picker/color-button.vue'
// import ColorInput from '@/components/color-picker/color-input.vue'

// export default {
//   name: 'ColorPicker',
//   components: { ColorButton, ColorInput },
//   props: {
//     label: { type: String, default: 'Label' },
//     name: { type: String, default: 'color' },
//     presets: {
//       type: Array,
//       default: () => [],
//     },
//     value: { type: String },
//   },
//   computed: {
//     selectedColor: {
//       get() {
//         return this.value
//       },
//       set(color) {
//         this.$emit('input', color)
//       },
//     },
//   },
// }
</script>
