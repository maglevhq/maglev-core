<template>
  <div>
    <dropdown
      placement="left"
      :dropup="false"
      ref="dropdown"
      class="h-full flex"
    >
      <template v-slot:button>
        <button
          class="
            h-full
            w-full
            px-6
            hover:bg-editor-primary hover:bg-opacity-5
            transition-colors
            duration-200
            flex
            items-center
            focus:outline-none focus:none
          "
        >
          <icon name="ri-global-line" class="mr-2" />
          <span class="mr-1">{{ currentLabel }}</span>
          <icon name="arrow-down-s-line" />
        </button>
      </template>
      <template v-slot:content>
        <div class="w-48 flex flex-col">
          <locale-link
            v-for="locale in locales"
            :locale="locale"
            :defaultLocale="defaultLocale"
            :key="locale.prefix"
          />
        </div>
      </template>
    </dropdown>
  </div>
</template>

<script>
import LocaleLink from './locale-link'

export default {
  name: 'LocaleToggler',
  components: { LocaleLink },
  computed: {
    currentLabel() {
      return this.locales.find((locale) => locale.prefix === this.currentLocale)
        ?.label
    },
    locales() {
      return this.currentSite.locales
    },
    defaultLocale() {
      return this.locales[0]
    },
  },
  watch: {
    currentLocale() {
      this.$refs.dropdown.close()
    },
  },
}
</script>
