<template>
  <div>
    <label class="block font-semibold text-gray-800" :for="name">
      {{ label }}
    </label>
    <div class="flex gap-2 mt-1">
      <div class="flex gap-2 mt-1">
        <div v-for="preset in presets" :key="preset">
          <input
            type="radio"
            name="selectedIcon"
            :id="`icon-${preset}`"
            :value="preset"
            class="hidden"
            v-model="selectedIcon"
          />
          <label
            :for="`icon-${preset}`"
            class="inline-block mr-1 cursor-pointer"
          >
            <i
              class="select-none text-2xl p-1 border-b-2 hover:border-gray-400"
              :class="[prefix, preset, {'border-editor-primary border-black shadow-xl': preset == selectedIcon}]"
            >
            </i>
          </label>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'IconPicker',
  props: {
    label: { type: String, default: 'Label' },
    name: { type: String, default: 'icon' },
    value: { type: String },
    presets: {
      type: Array,
      default: function () {
        return []
      },
    },
    prefix: { type: String, default: '' },
  },
  computed: {
    selectedIcon: {
      get() {
        return this.value
      },
      set(icon) {
        this.$emit('input', icon)
      },
    },
  },
}
</script>

<style>
/*TODO Replace fixed hostname by a variable */
@import url('http://localhost:3000/fonts/fonts.css');
</style>
