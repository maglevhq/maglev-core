<template>
  <uikit-icon :name="iconName" :size="size" />
</template>

<script>
export default {
  name: 'UIKitPageIcon',
  props: {
    page: { type: Object, required: true },
    size: { type: String, default: '1.25rem' },
  },
  computed: {
    iconName() {
      return this.isIndexPage ? 'home-4-line' : 'ri-file-line'
    },
    isIndexPage() {
      return this.services.page.isIndex(this.page)
    },
  },
}
</script>
