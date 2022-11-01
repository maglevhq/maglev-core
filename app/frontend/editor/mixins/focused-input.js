export default {
  props: {
    isFocused: { type: Boolean, default: false },
  },
  methods: {
    blur() {
      this.$emit('blur')
    },
  },
  watch: {
    isFocused: {
      immediate: true,
      handler(newValue, oldValue) {
        if (newValue && !oldValue) {
          this.$nextTick(() => this.focus())
        }
      },
    },
  },
}
