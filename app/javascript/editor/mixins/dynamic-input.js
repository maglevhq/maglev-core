export default {
  props: {
    setting: { type: Object, default: () => ({ type: 'text' }) },
    value: { required: true },
    isFocused: { type: Boolean, default: false },
    options: { type: Object },
  },
  computed: {
    inputValue: {
      get() {
        return this.value
      },
      set(value) {
        this.$emit('change', {
          settingId: this.setting.id,
          settingType: this.setting.type,
          settingOptions: this.setting.options,
          value,
        })
      },
    },
  },
}
