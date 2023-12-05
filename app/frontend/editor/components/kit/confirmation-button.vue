<template>
  <uikit-dropdown
    :placement="placement"
    v-on="$listeners"
    class="relative"
    ref="dropdown"
  >
    <template v-slot:button>
      <slot></slot>
    </template>
    <template v-slot:content>
      <div class="text-gray-700 text-md w-56">
        <p class="py-3">
          {{ text || $t('confirmationButton.text') }}
        </p>
        <div class="mt-1 flex flex-col">
          <button
            class="bg-red-600 rounded-sm text-white py-2 px-4"
            @click.stop="confirm"
          >
            {{
              confirmButtonLabel || $t('confirmationButton.confirmButtonLabel')
            }}
          </button>
          <button
            class="block w-full text-gray-800 py-2 hover:bg-gray-100 transition-colors duration-200"
            @click.stop="cancel"
          >
            {{
              cancelButtonLabel || $t('confirmationButton.cancelButtonLabel')
            }}
          </button>
        </div>
      </div>
    </template>
  </uikit-dropdown>
</template>

<script>
export default {
  name: 'UIKitConfirmationButton',
  props: {
    placement: { type: String, default: 'bottom' },
    text: { type: String, default: null },
    confirmButtonLabel: { type: String, default: null },
    cancelButtonLabel: { type: String, default: null },
  },
  methods: {
    isOpen() {
      return this.$refs.dropdown.open
    },
    confirm() {
      this.close()
      this.$emit('confirm')
    },
    cancel() {
      this.close()
      this.$emit('cancel')
    },
    close() {
      this.$refs.dropdown.close()
    },
  },
}
</script>
