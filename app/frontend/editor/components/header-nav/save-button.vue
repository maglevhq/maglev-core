<template>
  <uikit-submit-button
    type="button"
    class="block text-white bg-opacity-95 hover:bg-opacity-100 transition-colors duration-200"
    :class="{
      'w-40 h-full': big,
      'rounded-sm py-2 px-4 text-center w-32 border border-opacity-0': !big,
    }"
    defaultColorClass="bg-editor-primary"
    :labels="$t('headerNav.saveButton')"
    :buttonState="buttonState"
    @click="save"
  />
</template>

<script>
export default {
  name: 'SaveButton',
  props: {
    big: { type: Boolean, default: false },
  },
  computed: {
    buttonState() {
      return this.$store.state.ui.saveButtonState
    },
  },
  methods: {
    async save() {
      await this.$store.dispatch('persistPage')
    },
  },
}
</script>
