<template>
  <div>
    <uikit-text-input
      :label="$t(`linkPicker.email.input.label`)"
      name="email"
      v-model="emailInput"
    />
  </div>
</template>

<script>
export default {
  name: 'LinkEmailPicker',
  props: {
    currentLink: { type: Object, default: undefined },
  },
  computed: {
    emailInput: {
      get() {
        return this.currentLink.email
      },
      set(email) {
        this.$emit('change', {
          ...this.currentLink,
          email,
          href: `mailto:${email}`,
        })
      },
    },
  },
}
</script>
