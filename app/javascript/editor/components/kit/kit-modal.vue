<script setup>
defineProps({
  isOpen: Boolean,
  title: { type: String, default: 'Modal' },
  containerClass: { type: String, default: 'w-108' },
})

const emits = defineEmits(['onClose'])
</script>

<template>
  <transition name="modal">
    <div class="modal-mask" v-if="isOpen">
      <div class="modal-wrapper" @click="emits('onClose')">
        <div class="modal-container" :class="containerClass" @click.stop>
          <div class="modal-header">
            <slot name="header">
              <h3 class="text-gray-800 font-semibold antialiased text-lg">
                {{ title }}
              </h3>
            </slot>
            <button
              class="modal-close-button"
              type="button"
              @click="emits('onClose', true)"
            >
              <kit-icon name="ri-close-circle-line" />
            </button>
          </div>

          <div class="modal-body">
            <slot></slot>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>
