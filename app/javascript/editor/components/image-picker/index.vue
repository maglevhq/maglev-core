<template>
  <modal containerClass="w-216" v-if="show" @close="$emit('close')">
    <h3 class="text-gray-800 font-semibold antialiased text-lg" slot="header">
      {{ $t('imagePicker.title') }}
    </h3>

    <div class="mt-4" slot="body">
      <div class="flex items-center" v-if="!hasNoImagesYet">
        <image-uploader 
          :multiple="true"
          @uploaded="refresh" 
        />
        <search-input 
          class="w-72 ml-auto" 
          :placeholder="$t('imagePicker.searchPlaceholder')"
          @search="search"           
        />
      </div>
      <div class="mt-5">
        <div class="overflow-y-auto h-128" :class="{ 'invisible': images === null }">          
          <div class="mt-10 flex flex-col items-center" v-if="hasNoImagesYet">
            <p class="text-center">{{ $t('imagePicker.none') }}</p>
            <image-uploader @uploaded="refresh" :multiple="true" class="mt-4" />
          </div>
          <transition :name="slideDirection" mode="out-in" v-else>          
            <image-list 
              :images="images" 
              :key="activePage" 
              v-on="$listeners"
              @destroy="destroyImage"               
            />
          </transition>          
        </div>
        <pagination 
          labelI18nKey="imagePicker.pagination.label"
          noItemsI18nKey="imagePicker.pagination.noItems"
          :activePage="activePage"
          :totalItems="totalItems"
          :perPage="perPage"
          @change="page => this.activePage = page"
        />
      </div>
    </div>
  </modal>
</template>

<script>
import ImageUploader from './uploader'
import ImageList from './list'

export default {
  name: 'ImagePicker',
  components: { ImageUploader, ImageList },
  props: {
    show: { type: Boolean, default: false },
  },  
  data() {
    return { 
      images: null, totalItems: null, activePage: 1, perPage: 16, 
      slideDirection: null, query: null, loading: true
    }
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
        this.activePage, this.perPage, this.query
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
    show: {
      immediate: true,
      handler() {
        this.query = null
        if (this.show) this.fetch()   
      }
    },
    activePage(newActivePage, oldActivePage) {
      this.slideDirection = newActivePage > oldActivePage ? 'slide-left' : 'slide-right'
      this.fetch()
    },    
  }
}
</script>