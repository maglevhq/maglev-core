<template>
  <div class="mt-4">
    <div class="flex items-center" v-if="!hasNoImagesYet">
      <image-uploader
        :multiple="true"
        @uploaded="refresh"
        class="flex-shrink-0"
      />
      <search-input
        class="w-72 ml-auto"
        :placeholder="$t('imageLibrary.searchPlaceholder')"
        @search="search"
      />
    </div>
    <div class="mt-5">
      <div
        class="overflow-y-auto h-128"
        :class="{ invisible: images === null }"
      >
        <div class="mt-10 flex flex-col items-center" v-if="hasNoImagesYet">
          <p class="text-center">{{ $t('imageLibrary.none') }}</p>
          <image-uploader @uploaded="refresh" :multiple="true" class="mt-4" />
        </div>
        <transition :name="slideDirection" mode="out-in" v-else>
          <image-list
            :images="images"
            :key="activePage"
            :pickerMode="pickerMode"
            v-on="$listeners"
            @destroy="destroyImage"
          />
        </transition>
      </div>
      <pagination
        labelI18nKey="imageLibrary.pagination.label"
        noItemsI18nKey="imageLibrary.pagination.noItems"
        :activePage="activePage"
        :totalItems="totalItems"
        :perPage="perPage"
        @change="page => (this.activePage = page)"
      />
    </div>
  </div>
</template>

<script>
import ImageUploader from './uploader'
import ImageList from './list'

export default {
  name: 'ImageLibrary',
  components: { ImageUploader, ImageList },
  props: {
    pickerMode: { type: Boolean, default: false },
  },
  data() {
    return {
      images: null,
      totalItems: null,
      activePage: 1,
      perPage: 16,
      slideDirection: null,
      query: null,
      loading: true,
    }
  },
  mounted() {
    this.query = null
    this.fetch()
  },
  computed: {
    hasNoImagesYet() {
      return this.isBlank(this.images) && this.query === null && !this.loading
    },
  },
  methods: {
    async fetch() {
      this.loading = true
      let { data, totalItems } = await this.services.image.findAll(
        this.activePage,
        this.perPage,
        this.query,
      )
      this.images = data
      this.totalItems = totalItems
      this.loading = false
    },
    search(query) {
      this.loading = true
      this.query = query
      this.fetch()
    },
    refresh() {
      this.activePage = 1
      this.fetch()
    },
    async destroyImage(image) {
      await this.services.image.destroy(image.id)
      this.fetch()
    },
  },
  watch: {
    activePage(newActivePage, oldActivePage) {
      this.slideDirection =
        newActivePage > oldActivePage ? 'slide-left' : 'slide-right'
      this.fetch()
    },
  },
}
</script>
