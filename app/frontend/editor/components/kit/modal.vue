<template>
  <transition name="modal">
    <div class="modal-mask" v-if="isOpen">
      <div class="modal-wrapper" @click="$emit('on-close')">
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
              @click="$emit('on-close', true)"
            >
              <uikit-icon-button iconName="ri-close-line" class="relative -right-2" />
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

<script>
export default {
  name: 'UIKitModal',
  props: {
    isOpen: Boolean,
    title: { type: String, default: 'Modal' },
    containerClass: { type: String, default: 'w-108' },
  },
}
</script>
