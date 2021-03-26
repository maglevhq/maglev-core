<template>
  <transition name="modal">
    <div class="modal-mask">
      <div class="modal-wrapper">
        <div class="modal-container" :class="containerClass">

          <div class="modal-header">
            <slot name="header">
              default header
            </slot>
            <button class="modal-close-button" type="button" @click="$emit('close')">
              <icon name="ri-close-circle-line" />
            </button>
          </div>

          <div class="modal-body">
            <slot name="body">
              default body
            </slot>
          </div>          
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
export default {
  name: 'Modal',
  props: {
    containerClass: { type: String, default: 'w-108' }
  },
  created() {
    document.addEventListener('keyup', event => {
      if (event.keyCode === 27) {
        this.$emit('close')
      }
    })
  },
}
</script>
