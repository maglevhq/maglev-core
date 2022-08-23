<script setup>
import { onMounted } from 'vue'
import useErrorModal from '@/hooks/error-modal'

const { openErrorModal } = useErrorModal()

onMounted(() => {
  openErrorModal('staleRecord')
})
</script>

<template>
  <div>
    <h1>WIP</h1>
    <kit-modal-root />
  </div>
</template>
