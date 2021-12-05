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

    <text-input
      :label="$t(`page.form.ogTitle`)"
      name="og-title"
      v-model="ogTitleInput"
    />

    <textarea-input
      :label="$t(`page.form.ogDescription`)"
      name="og-description"
      v-model="ogDescriptionInput"
    />

    <image-input
      :label="$t(`page.form.ogImageUrl`)"
      name="og-image-url"
      :hasAltText="false"
      v-model="ogImageUrlInput"
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
    ogTitleInput: {
      get() {
        return this.page.ogTitle
      },
      set(ogTitle) {
        this.$emit('on-change', { ogTitle })
      },
    },
    ogDescriptionInput: {
      get() {
        return this.page.ogDescription
      },
      set(ogDescription) {
        this.$emit('on-change', { ogDescription })
      },
    },
    ogImageUrlInput: {
      get() {
        return { url: this.page.ogImageUrl }
      },
      set(ogImage) {
        this.$emit('on-change', { ogImageUrl: ogImage.url })
      },
    },
  },
}
</script>
