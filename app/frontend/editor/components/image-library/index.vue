<template>
  <div class="h-156 flex flex-col space-y-5">
    <div class="flex items-center h-10" v-if="!hasNoImagesYet">
      <image-uploader
        :multiple="true"
        @uploaded="refresh"
        class="flex-shrink-0"
      />
      <uikit-search-input
        class="w-72 ml-auto"
        :placeholder="$t('imageLibrary.searchPlaceholder')"
        @search="search"
      />
    </div>
    <div class="grow overflow-y-auto">
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
    <uikit-pagination
      class="shrink-0"
      labelI18nKey="imageLibrary.pagination.label"
      noItemsI18nKey=""
      :activePage="activePage"
      :totalItems="totalItems"
      :perPage="perPage"
      @change="(page) => (this.activePage = page)"
      v-if="!hasNoImagesYet"
    />
  </div>
</template>

<script>
import ImageUploader from './uploader.vue'
import ImageList from './list.vue'

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
      return this.isBlank(this.images) && this.query === null
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
