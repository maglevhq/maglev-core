<template>
  <button
    :type="type"
    :class="{ [buttonClass]: true }"
    :disabled="disabled || isInProgressState"
    @click="click"
  >
    <span v-if="isDefaultState" data-button-label>{{ defaultLabel }}</span>

    <span v-if="isInProgressState" class="flex items-center justify-center">
      <uikit-icon name="ri-loader-4-line" spin color="#fff" key="progress" />
      <span class="ml-2" data-button-label>{{ inProgressLabel }}</span>
    </span>

    <span v-if="isSuccessState" class="flex items-center justify-center">
      <uikit-icon name="ri-check-line" color="#fff" key="success" />
      <span class="ml-2" data-button-label>{{ successLabel }}</span>
    </span>

    <span v-if="isFailState" class="flex items-center justify-center">
      <uikit-icon name="ri-alert-line" color="#fff" key="fail" />
      <span class="ml-2" data-button-label>{{ failLabel }}</span>
    </span>
  </button>
</template>

<script>
export default {
  name: 'UIKitSubmitButton',
  props: {
    type: {
      type: String,
      default: 'submit',
    },
    disabled: {
      type: Boolean,
      default: false,
    },
    labels: {
      type: Object,
      default: undefined,
    },
    buttonState: {
      type: String,
      default: 'default',
    },
    defaultColorClass: {
      type: String,
      default: 'bg-gray-700',
    },
  },
  data() {
    return {
      internalButtonState: 'default',
      timeout: undefined,
    }
  },
  computed: {
    isDefaultState() {
      return this.internalButtonState === 'default'
    },
    defaultLabel() {
      return this.labels?.default || 'Submit'
    },
    isInProgressState() {
      return this.internalButtonState === 'inProgress'
    },
    inProgressLabel() {
      return this.labels?.inProgress || 'Loading'
    },
    isSuccessState() {
      return this.internalButtonState === 'success'
    },
    successLabel() {
      return this.labels?.success || 'Success!'
    },
    isFailState() {
      return this.internalButtonState === 'fail'
    },
    failLabel() {
      return this.labels?.fail || 'Failure!'
    },
    buttonClass() {
      switch (this.internalButtonState) {
        case 'default':
          return this.defaultColorClass
        case 'inProgress':
          return `${this.defaultColorClass} bg-opacity-75`
        case 'success':
          return 'bg-green-500'
        case 'fail':
          return 'bg-red-600'
      }
      return ''
    },
  },
  methods: {
    click() {
      if (this.type === 'button' && this.isDefaultState) this.$emit('click')
    },
  },
  watch: {
    buttonState: {
      immediate: true,
      handler(newValue) {
        this.internalButtonState = newValue
        if (newValue === 'success' || newValue === 'fail') {
          if (this.timeout) clearTimeout(this.timeout)
          this.timeout = setTimeout(() => {
            this.internalButtonState = 'default'
          }, 3000)
        }
      },
    },
  },
}
</script>
