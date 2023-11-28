<template>
  <uikit-dropdown v-on="$listeners" class="absolute top-1.5 right-1">
    <template v-slot:button>
      <button
        class="px-1 py-1 hover:text-gray-900 focus:outline-none transition-colors duration-200"
      >
        <uikit-icon name="ri-palette-line" size="1.25rem" />
      </button>
    </template>
    <template v-slot:content>
      <div class="flex flex-wrap gap-1">
        <preset-button
          v-for="preset in presets"
          v-model="updatableValue"
          :preset="preset"
          :key="preset"
        />
      </div>
    </template>
  </uikit-dropdown>
</template>

<script>
import PresetButton from './preset-button.vue'

export default {
  name: 'PresetDropdown',
  components: { PresetButton },
  props: {
    value: { type: String },
    presets: {
      type: Array,
      default: () => [],
    },
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
