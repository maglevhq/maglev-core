<template>
  <div class="mt-2 grid grid-cols-1 gap-4">
    <uikit-text-input
      :label="$t(`page.form.title`)"
      name="title"
      v-model="titleInput"
      :error="errors.title"
    />

    <uikit-text-input
      :label="$t(`page.form.path`)"
      name="path"
      v-model="pathInput"
      :error="errors.path || errors['paths.value'] || errors['pathsValue']"
      v-if="!isPageIndex || !page.id"
    />

    <uikit-simple-select
      :label="$t(`page.form.layoutId`)"
      name="layoutId"
      v-model="layoutIdInput"
      :error="errors.layoutId"
      :selectOptions="pageLayouts"
      v-if="hasMultiplePageLayouts"
    />

    <uikit-checkbox-input
      :label="$t(`page.form.visible`)"
      :placeholder="$t(`page.form.visiblePlaceholder`)"
      name="visible"
      v-model="visibleInput"
    />
  </div>
</template>

<script>
export default {
  name: 'PageMainForm',
  props: {
    page: { type: Object, required: true },
    errors: { type: Object, default: () => {} },
  },
  computed: {
    isPageIndex() {
      return this.services.page.isIndex(this.page)
    },
    titleInput: {
      get() {
        return this.page.title
      },
      set(title) {
        this.$emit('on-change', { title })
      },
    },
    pathInput: {
      get() {
        return this.page.path
      },
      set(path) {
        this.$emit('on-change', { path })
      },
    },
    layoutIdInput: {
      get() {
        return this.page.layoutId
      },
      set(layoutId) {
        this.$emit('on-change', { layoutId })
      },
    },
    visibleInput: {
      get() {
        return this.page.visible
      },
      set(visible) {
        this.$emit('on-change', { visible })
      },
    },
    pageLayouts() {
      return this.services.theme.buildLayoutOptions(this.currentTheme)
    },
    hasMultiplePageLayouts() {
      return this.pageLayouts.length > 1
    }
  },
}
</script>
