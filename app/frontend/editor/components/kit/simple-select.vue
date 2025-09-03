<template>
  <div>
    <label class="block font-semibold text-gray-800" :for="name">
      {{ label }}
    </label>
    <div class="flex gap-2 mt-1">
      <select
        v-model="selectedOption"
        class="block w-full mt-1 py-2 px-3 rounded bg-gray-100 text-gray-800 focus:outline-none focus:ring placeholder-gray-500"
      >
        <option
          v-for="(option, index) in selectOptions"
          :key="index"
          :value="getOptionValue(option)"
        >
          {{ getOptionLabel(option) }}
        </option>
      </select>
    </div>
  </div>
</template>

<script>
export default {
  name: 'UIKitSimpleSelect',
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
    i18nScope: { type: String, default: 'support.simpleSelect' },
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
  methods: {
    getOptionLabel(option) {
      const value = this.getOptionValue(option)
      const i18nKey = `${this.i18nScope}.${this.name}_options.${value}`
      const translatedLabel = this.$st(i18nKey)

      if (!this.isBlank(translatedLabel)) return translatedLabel

      return typeof option === 'string' ? option : option.label
    },
    getOptionValue(option) {
      return (typeof option === 'string') ? option : option.value
    },
  },
}
</script>
