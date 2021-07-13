<template>
  <div class="mt-2 grid grid-cols-1 gap-4">
    <text-input
      :label="$t(`page.form.seoTitle`)"
      name="seo-title"
      v-model="seoTitleInput"
    />

    <textarea-input
      :label="$t(`page.form.metaDescription`)"
      name="meta-description"
      v-model="metaDescriptionInput"
    />
  </div>
</template>

<script>
export default {
  name: 'PageSEOForm',
  props: {
    page: { type: Object, required: true },
    errors: { type: Object, default: () => {} },
  },
  computed: {
    seoTitleInput: {
      get() {
        return this.page.seoTitle
      },
      set(seoTitle) {
        this.$emit('on-change', { seoTitle })
      },
    },
    metaDescriptionInput: {
      get() {
        return this.page.metaDescription
      },
      set(metaDescription) {
        this.$emit('on-change', { metaDescription })
      },
    },
  },
}
</script>
