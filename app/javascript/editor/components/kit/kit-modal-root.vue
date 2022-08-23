<script setup>
import { computed, onMounted, onBeforeUnmount } from 'vue'
import { useUIStore } from '@/stores/ui-store'

const uiStore = useUIStore()

const modals = computed(() => uiStore.modals)
const currentModal = computed(() => uiStore.currentModal)
const hasCurrentModal = computed(() => !!currentModal.value)
const title = computed(() => currentModal.value?.title)
const containerClass = computed(() => currentModal.value?.props?.modalClass)
const closeOnClick = computed(() => currentModal.value?.closeOnClick)

const closeModal = () => uiStore.closeModal()
const handleOutsideClick = (force) => {
  if (!closeOnClick.value && !force) return
  closeModal()
}
const handleKeyup = (e) => {
  if (e.keyCode === 27) closeModal()
}

onMounted(() => {
  document.addEventListener('keyup', handleKeyup)
})

onBeforeUnmount(() => {
  document.removeEventListener('keyup', handleKeyup)
})
</script>

<template>
  <kit-modal
    :isOpen="hasCurrentModal"
    :title="title"
    :containerClass="containerClass"
    @on-close="handleOutsideClick"
  >
    <component
      v-for="(modal, index) in modals"
      :key="`modal-${index}`"
      :is="modal.component"
      @on-close="closeModal"
      v-bind="modal.props"
      v-on="modal.listeners"
      v-show="index === modals.length - 1"
    />
  </kit-modal>
</template>
