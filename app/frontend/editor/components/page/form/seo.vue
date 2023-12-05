<template>
  <div class="mt-2 grid grid-cols-1 gap-4">
    <uikit-textarea-input
      :label="$t(`page.form.seoTitle`)"
      name="seo-title"
      :max-length="60"
      :rows="2"
      v-model="seoTitleInput"
    />

    <uikit-textarea-input
      :label="$t(`page.form.metaDescription`)"
      name="meta-description"
      :max-length="155"
      :rows="5"
      v-model="metaDescriptionInput"
    />

    <uikit-textarea-input
      :label="$t(`page.form.ogTitle`)"
      name="og-title"
      :max-length="60"
      :rows="2"
      v-model="ogTitleInput"
    />

    <uikit-textarea-input
      :label="$t(`page.form.ogDescription`)"
      name="og-description"
      :max-length="200"
      :rows="6"
      v-model="ogDescriptionInput"
    />

    <uikit-image-input
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
        this.$emit('on-change', { ogImageUrl: ogImage?.url ?? null })
      },
    },
  },
}
</script>
