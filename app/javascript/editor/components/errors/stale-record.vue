<script setup>
const reloadPage = () => window.location.reload()
</script>

<template>
  <div class="pt-8 pb-4">
    <p class="text-gray-600 text-justify">
      {{ $t('errorModals.staleRecord.message') }}
    </p>

    <div class="mt-8 text-center">
      <button class="big-submit-button bg-editor-primary" @click="reloadPage">
        {{ $t('errorModals.staleRecord.button') }}
      </button>
    </div>
  </div>
</template>
