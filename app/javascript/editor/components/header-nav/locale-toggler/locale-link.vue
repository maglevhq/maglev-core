<template>
  <router-link
    :to="{
      name: 'editPage',
      params: { locale: locale.prefix, pageId: pageId },
    }"
    :key="locale.prefix"
    class="flex items-center px-4 py-4 hover:bg-gray-100 transition-colors duration-200 focus:outline-none cursor-pointer text-md"
    :class="{ 'font-bold': isActive }"
  >
    {{ locale.label }}
  </router-link>
</template>

<script>
export default {
  name: 'LocaleTogglerLink',
  props: {
    locale: { type: Object, required: true },
    defaultLocale: { type: Object, required: true },
  },
  computed: {
    isActive() {
      return this.locale.prefix === this.currentLocale
    },
    pageId() {
      const map = this.currentPage.pathHash
      return map[this.locale.prefix] || map[this.defaultLocale.prefix]
    },
  },
}
</script>
