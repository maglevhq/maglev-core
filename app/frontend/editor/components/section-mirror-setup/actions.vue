<template>
  <div class="pt-6 flex flex-col px-1">
    <button
      class="big-submit-button bg-editor-primary"
      type="button"
      :disabled="disabled"
      @click="$emit('confirm')"
    >
      {{ $t('mirrorSectionSetup.confirmButton') }}
    </button>

    <button class="cancel-button" type="button" @click="$emit('on-close')">
      {{ $t('mirrorSectionSetup.cancelButton') }}
    </button>
  </div>
</template>

<script>
export default {
  name: 'SectionMirrorSetupActions',
  props: {
    disabled: { type: Boolean, default: true },
  },
}
</script>