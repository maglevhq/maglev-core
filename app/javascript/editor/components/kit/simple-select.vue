<template>
  <div>
    <label class="block font-semibold text-gray-800" :for="name">
      {{ label }}
    </label>
    <div class="flex gap-2 mt-1">
      <select
        v-model="selectedOption"
        class="
          block
          w-full
          mt-1
          py-2
          px-3
          rounded
          bg-gray-100
          text-gray-800
          focus:outline-none focus:ring
          placeholder-gray-500
        "
      >
        <option v-for="option in selectOptions" :key="option" :value="option">
          {{ option }}
        </option>
      </select>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Simple-Select',
  props: {
    label: { type: String, default: 'Label' },
    name: { type: String, default: 'select' },
    value: { type: String },
    selectOptions: {
      type: Array,
      default: function () {
        return []
      },
    },
  },
  computed: {
    selectedOption: {
      get() {
        return this.value
      },
      set(option) {
        this.$emit('input', option)
      },
    },
  },
}
</script>
