<template>
  <div class="pt-8 pb-4 space-y-4">
    <p class="text-gray-600 text-justify">
      {{ $t('errorModals.staleRecord.message') }}
    </p>

    <div class="text-center">
      <button class="big-submit-button bg-editor-primary" @click="reloadPage">
        {{ $t('errorModals.staleRecord.button') }}
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'StaleRecordError',
  methods: {
    reloadPage() {
      window.location.reload()
    },
  },
}
</script>
