<template>
  <div class="pt-8 pb-4">
    <p class="text-gray-600 text-justify">
      {{ $t('errorModals.forbidden.message') }}
    </p>

    <div class="mt-4 text-center">
      <button class="big-submit-button bg-editor-primary" @click="close">
        {{ $t('errorModals.forbidden.button') }}
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ForbiddenError',
  methods: {
    close() {
      this.closeModal()
    },
  },
}
</script>
