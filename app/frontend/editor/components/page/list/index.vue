<template>
  <div>
    <div key="empty-list" class="pt-4 text-center" v-if="isEmpty">
      No pages found
    </div>
    <div key="list" v-else>
      <list-item
        v-for="page in previewablePages"
        :key="page.id"
        :page="page"
        @on-update="fetch"
        @on-clone="fetch"
        @on-delete="fetch"
        @on-dropdown-toggle="onDropdownToggle"
      />
    </div>
  </div>
</template>

<script>
import GroupedDropdownsMixin from '@/mixins/grouped-dropdowns'
import ListItem from './list-item.vue'

export default {
  name: 'PageList',
  mixins: [GroupedDropdownsMixin],
  components: { ListItem },
  props: {
    q: { type: String, required: false },
  },
  data() {
    return { pages: [], isLoading: true }
  },
  computed: {
    isEmpty() {
      return this.previewablePages.length === 0 && !this.isLoading
    },
    previewablePages() {
      return this.pages.filter((page) => !!page.previewUrl && !page.static)
    },
  },
  methods: {
    async fetch() {
      this.isLoading = true
      this.pages = await this.services.page.findAll({ q: this.q })
      this.isLoading = false
    },
  },
  watch: {
    q: {
      immediate: true,
      handler() {
        this.fetch()
      },
    },
  },
}
</script>
