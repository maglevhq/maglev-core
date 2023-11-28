<template>
  <div>
    <uikit-text-input
      :label="$t(`linkPicker.url.input.label`)"
      name="href"
      v-model="hrefInput"
    />

    <uikit-checkbox-input
      :label="$t(`linkPicker.shared.newWindowInput.label`)"
      name="openNewWindow"
      class="mt-6"
      v-model="openNewWindowInput"
    />
  </div>
</template>

<script>
export default {
  name: 'LinkUrlPicker',
  props: {
    currentLink: { type: Object, default: undefined },
  },
  computed: {
    hrefInput: {
      get() {
        return this.currentLink.href
      },
      set(href) {
        this.$emit('change', { ...this.currentLink, href })
      },
    },
    openNewWindowInput: {
      get() {
        return this.currentLink.openNewWindow
      },
      set(openNewWindow) {
        this.$emit('change', { ...this.currentLink, openNewWindow })
      },
    },
  },
}
</script>
