<template>
  <div>
    <label :for="name" class="flex items-center cursor-pointer">
      <div class="font-semibold text-gray-800">
        {{ label }}
      </div>
      <div class="ml-auto relative">
        <input :id="name" type="checkbox" class="hidden" v-model="localValue" />
        <div class="toggle__line w-10 h-6 bg-gray-200 rounded-full"></div>
        <div
          class="toggle__dot absolute w-5 h-5 bg-white rounded-full inset-y-0 left-0 transition duration-200 ease-in-out"
        ></div>
      </div>
    </label>
    <div class="text-gray-600 text-sm" v-if="hasPlaceholder">
      {{ placeholder }}
    </div>
  </div>
</template>

<script>
export default {
  name: 'UIKitCheckboxInput',
  props: {
    label: { type: String, default: 'Label' },
    name: { type: String, default: 'text' },
    value: { type: Boolean, default: false },
    placeholder: { type: String, default: null },
  },
  computed: {
    localValue: {
      get() {
        return this.value
      },
      set(value) {
        this.$emit('input', value)
      },
    },
    hasPlaceholder() {
      return !this.isBlank(this.placeholder)
    },
  },
}
</script>

<style scoped>
.toggle__dot {
  top: theme('spacing.1/2');
  left: theme('spacing.1/2');
}

input:checked ~ .toggle__dot {
  transform: translateX(calc(100% - theme('spacing.1')));
}

input:checked ~ .toggle__line {
  @apply bg-editor-primary;
}
</style>
