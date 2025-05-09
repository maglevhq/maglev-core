<template>
  <div>
    <transition name="fade" mode="out-in">
      <div key="list-placeholder" v-if="isLoading">
        <div class="flex flex-col items-center w-full animate-pulse">
          <div class="h-12 bg-gray-200 rounded w-full mb-3"></div>
          <div class="h-12 bg-gray-200 rounded w-full mb-3"></div>
          <div class="h-12 bg-gray-200 rounded w-full mb-3"></div>
        </div>
      </div>
      <div key="empty-list" class="pt-4 text-center" v-else-if="isEmpty">
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
    </transition>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
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
      return this.previewablePages.length === 0
    },
    previewablePages() {
      return this.pages.filter((page) => !!page.previewUrl && !page.static)
    },
  },
  methods: {
    ...mapActions(['setOneSinglePage']),
    async fetch() {
      this.isLoading = true
      this.pages = await this.services.page.findAll({ q: this.q })
      this.setOneSinglePage(this.previewablePages.length === 1)
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
