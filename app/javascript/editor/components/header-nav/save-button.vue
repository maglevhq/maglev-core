<template>
  <submit-button
    type="button"
    class="block text-white w-40 h-full bg-opacity-95 hover:bg-opacity-100 transition-colors duration-200"
    defaultColorClass="bg-editor-primary"
    :labels="$t('headerNav.saveButton')"
    :buttonState="buttonState"
    @click="save"
  />
</template>

<script>
export default {
  name: 'SaveButton',
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

<style scoped>
.bg-editor-primary {
  background-color: rgba(
    var(--editor-color-primary-non-hex),
    var(--tw-bg-opacity)
  );
}
</style>
