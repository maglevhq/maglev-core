<template>
  <div class="mt-10 flex flex-col px-1">
    <button
      class="big-submit-button bg-editor-primary"
      type="button"
      :disabled="disabled"
      @click="$emit('select', link)"
    >
      {{ $t(`${i18nScope}.mainButton.${mode}`) }}
    </button>

    <button class="cancel-button" type="button" @click="$emit('on-close')">
      {{ $t(`${i18nScope}.cancelButton`) }}
    </button>
  </div>
</template>

<script>
export default {
  name: 'LinkPickerActions',
  props: {
    link: { type: Object, required: true },
    mode: { type: String, default: 'select' },
    disabled: { type: Boolean, default: true },
  },
  computed: {
    i18nScope() {
      return 'linkPicker.shared'
    },
  },
}
</script>
