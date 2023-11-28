<template>
  <div class="flex justify-between items-center h-12">
    <div class="text-sm">
      <span v-if="totalItems > 0">
        {{ $t(labelI18nKey, { start, end, totalItems }) }}
      </span>
      <span v-else>
        {{ $t(noItemsI18nKey) }}
      </span>
    </div>
    <div class="flex items-center" v-if="visible">
      <page-button :page="activePage - 1" @click="change" class="mr-1">
        <uikit-icon name="arrow-drop-left" />
      </page-button>

      <page-button
        :page="1"
        :activePage="activePage"
        @click="change"
        class="mr-1"
      />

      <page-button
        v-for="(page, index) in pages"
        :key="`page-${index}`"
        :page="page"
        :activePage="activePage"
        @click="change"
        class="mr-1"
      />

      <page-button
        :page="totalPages"
        :activePage="activePage"
        @click="change"
        class="mr-1"
      />

      <page-button :page="activePage + 1" @click="change">
        <uikit-icon name="arrow-drop-right" />
      </page-button>
    </div>
  </div>
</template>

<script>
// Inspired by https://github.com/arnedesmedt/vue-ads-pagination (MIT License)
import PageButton from './button.vue'

export default {
  name: 'UIKitPagination',
  components: { PageButton },
  props: {
    labelI18nKey: { type: String, default: 'pagination.defaultLabel' },
    noItemsI18nKey: { type: String, default: 'pagination.defaultNoItems' },
    activePage: { type: Number, default: 1 },
    perPage: { type: Number, default: 10 },
    totalItems: { type: Number, default: 1 },
    maxVisiblePages: { type: Number, default: 5 },
  },
  computed: {
    visible() {
      return this.totalItems > this.perPage
    },
    start() {
      return (this.activePage - 1) * this.perPage + 1
    },
    end() {
      let end = this.activePage * this.perPage
      return end > this.totalItems - 1 ? this.totalItems : end
    },
    totalPages() {
      return this.perPage === 0 ? 0 : Math.ceil(this.totalItems / this.perPage)
    },
    pages() {
      let filteredPages = this.filteredPages
      return filteredPages
        ? [
            filteredPages[0] - 1 === 2 ? 2 : '...',
            ...filteredPages,
            filteredPages[filteredPages.length - 1] === this.totalPages - 2
              ? this.totalPages - 1
              : '...',
          ]
        : [...Array(this.totalPages - 2).keys()].map((page) => page + 2)
    },
    filteredPages() {
      let diff = this.maxVisiblePages / 2
      let toFilterPages = [...Array(this.totalPages).keys()]
        .map((page) => page + 1)
        .slice(2, -2)
      if (toFilterPages.length > this.maxVisiblePages) {
        let diffFirst = this.activePage - toFilterPages[0]
        let diffLast = this.activePage - toFilterPages[toFilterPages.length - 1]
        if (diffFirst < diff) {
          return toFilterPages.slice(0, this.maxVisiblePages)
        } else if (diffLast >= -diff) {
          return toFilterPages.slice(-this.maxVisiblePages)
        } else {
          return toFilterPages.filter((page) => {
            let diffPage = this.activePage - page
            return diffPage < 0 ? Math.abs(diffPage) <= diff : diffPage < diff
          })
        }
      }
      return null
    },
  },
  methods: {
    change(page) {
      if (page < 1 || page > this.totalPages || page === '...') return
      this.$emit('change', page)
    },
  },
}
</script>
