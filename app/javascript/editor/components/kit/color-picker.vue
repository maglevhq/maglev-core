<template>
  <div>
    <label class="block font-semibold text-gray-800" :for="name">
      {{ label }}
    </label>
    <div class="flex gap-2 mt-1">
      <div v-for="preset in presets" :key="preset">
        <input type="radio" name="selectedColor" :id="`color_${preset}`" :value="preset" class="hidden" v-model="selectedColor"/>
        <label :for="`color_${preset}`" :title="preset"
               class="inline-block w-6 h-6 mr-1 cursor-pointer">
          <span class="block w-full h-full rounded-full transition transform duration-200 ease-in-out hover:scale-110 select-none"
                :style="`background-color: ${preset};`"
                :class="{'border-2 border-black shadow-xl': preset == selectedColor}"
          >

          </span>
        </label>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ColorPicker',
  props: {
    label: {type: String, default: 'Label'},
    name: {type: String, default: 'color'},
    presets: {
      type: Array, default: function () {
        return []
      }
    },
    value: {type: String },
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
  },
}
</script>
