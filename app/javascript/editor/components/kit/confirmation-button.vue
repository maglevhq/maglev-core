<template>
  <dropdown :placement="placement" :dropup="dropup" ref="dropdown">
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
            @click="confirm"
          >
            {{ confirmButtonLabel || $t('confirmationButton.confirmButtonLabel') }}
          </button>
          <button
            class="block text-gray-600 hover:text-gray-800 mt-4"
            @click="cancel"
          >                    
            {{ cancelButtonLabel || $t('confirmationButton.cancelButtonLabel') }}
          </button>
        </div>
      </div>
    </template>
  </dropdown>      
</template>

<script>
export default {
  name: 'ConfirmationButton',
  props: {
    placement: { type: String, default: 'right' },
    dropup: { type: Boolean, default: false },
    text: { type: String, default: null },
    confirmButtonLabel: { type: String, default: null },
    cancelButtonLabel: { type: String, default: null },
  },
  methods: {
    isOpen() {
      return this.$refs.dropdown.open
    },
    confirm() {
      this.$refs.dropdown.close()
      this.$emit('confirm')
    },
    cancel() {
      this.$refs.dropdown.close()
      this.$emit('cancel')
    }
  }
}
</script>
