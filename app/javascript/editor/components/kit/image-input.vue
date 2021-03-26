<template>
  <div>
    <label class="block font-bold text-gray-800" :for="name">
      {{ label }}
    </label>
    <div class="mt-1">
      <div class="flex items-center justify-center bg-gray-100 h-48 rounded" v-if="isBlank(value)">
        <button class="flex items-center justify-center flex-col" @click="openImagePicker">
          <icon name="camera-line" />
          <p class="uppercase text-xs mt-1">{{ $t('imageInput.addButton') }}</p>
        </button>
      </div>
      <div v-else>
        <div class="relative bg-gray-100 h-48 rounded overflow-hidden" @mouseover="hovered = true" @mouseleave="hovered = false">
          <img 
            class="h-full w-full object-cover rounded" 
            :src="value.url" 
            @error="() => this.errorOnLoading = true"
            v-if="isValidImage"
          />
          <transition name="slide-up">
            <div 
              class="flex justify-center py-3 px-2 absolute bg-black bg-opacity-75 bottom-0 w-full text-white cursor-default rounded-b"
              v-if="hovered"
            >
              <button class="flex items-center justify-center flex-col mr-4" @click="openImagePicker">
                <icon name="camera-line" />
                <p class="uppercase text-xs mt-1">{{ $t('imageInput.replaceButton') }}</p>
              </button>

              <button class="flex items-center justify-center flex-col" @click="removeImage">
                <icon name="delete-bin-line" />
                <p class="uppercase text-xs mt-1">{{ $t('imageInput.clearButton') }}</p>
              </button>
            </div>
          </transition>
        </div>

        <text-input 
          class="mt-2"
          :showLabel="false"
          :placeholder="$t('imageInput.altTextPlaceholder')"
          v-model="altText" 
        />
      </div>      
    </div>

    <image-picker
      :show="showImagePicker"
      @select="onSelectImage"
      @close="closeImagePicker"
    />
  </div>
</template>

<script>
import ImagePicker from '@/components/image-picker'

export default {
  name: 'ImageInput',
  components: { ImagePicker },
  props: {
    label: { type: String, default: 'Label' },
    name: { type: String, default: 'image' },
    value: { default: () => ({ altText: '' }) },
  },  
  data() {
    return { showImagePicker: false, hovered: false, errorOnLoading: false }
  },
  computed: {
    altText: {
      get() { return this.value.altText },
      set(altText) { this.$emit('input', { ...this.value, altText }) }
    },
    isValidImage() {
      return !this.isBlank(this.value?.url) && !this.errorOnLoading
    }
  },
  methods: {
    openImagePicker() { 
      this.showImagePicker = true
    },
    closeImagePicker() {
      this.showImagePicker = false
    },  
    removeImage() {
      this.$emit('input', null)
    },    
    onSelectImage(image) {      
      this.closeImagePicker()
      this.$emit('input', { ...this.value, ...image })
      this.errorOnLoading = false
    }
  },    
}
</script>