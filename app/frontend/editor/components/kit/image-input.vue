<template>
  <div>
    <div class="block font-semibold text-gray-800" @click="focus()">
      {{ label }}
    </div>
    <div class="mt-1">
      <div
        class="flex items-center justify-center bg-gray-100 h-48 rounded"
        v-if="isBlank(value)"
      >
        <button
          class="flex items-center justify-center flex-col"
          @click="openImagePickerModal"
        >
          <uikit-icon name="camera-line" />
          <p class="uppercase text-xs mt-1">{{ $t('imageInput.addButton') }}</p>
        </button>
      </div>
      <div v-else>
        <div
          class="relative bg-checkerboard h-48 rounded overflow-hidden"
          @mouseover="hovered = true"
          @mouseleave="hovered = false"
        >
          <img
            class="h-full w-full object-contain rounded"
            :src="value.url"
            @error="() => (this.errorOnLoading = true)"
            v-if="isValidImage"
          />
          <transition name="slide-up">
            <div
              class="flex justify-center py-3 px-2 absolute bg-black bg-opacity-75 bottom-0 w-full text-white cursor-default rounded-b"
              v-if="hovered"
            >
              <button
                class="flex items-center justify-center flex-col mr-4"
                @click="openImagePickerModal"
              >
                <uikit-icon name="camera-line" />
                <p class="uppercase text-xs mt-1">
                  {{ $t('imageInput.replaceButton') }}
                </p>
              </button>

              <button
                class="flex items-center justify-center flex-col"
                @click="removeImage"
              >
                <uikit-icon name="delete-bin-line" />
                <p class="uppercase text-xs mt-1">
                  {{ $t('imageInput.clearButton') }}
                </p>
              </button>
            </div>
          </transition>
        </div>

        <uikit-text-input
          class="mt-2"
          :showLabel="false"
          :placeholder="$t('imageInput.altTextPlaceholder')"
          v-model="altText"
          v-if="hasAltText"
        />
      </div>
    </div>
  </div>
</template>

<script>
import FocusedInputMixin from '@/mixins/focused-input'
import ImageLibrary from '@/components/image-library/index.vue'

export default {
  name: 'UIKitImageInput',
  mixins: [FocusedInputMixin],
  props: {
    label: { type: String, default: 'Label' },
    name: { type: String, default: 'image' },
    value: { default: () => ({ altText: '' }) },
    hasAltText: { type: Boolean, default: true, required: false },
  },
  data() {
    return { hovered: false, errorOnLoading: false }
  },
  computed: {
    altText: {
      get() {
        return this.value.altText
      },
      set(altText) {
        this.$emit('input', { ...this.value, altText })
      },
    },
    isValidImage() {
      return !this.isBlank(this.value?.url) && !this.errorOnLoading
    },
  },
  methods: {
    focus() {
      this.openImagePickerModal()
    },
    openImagePickerModal() {
      this.openModal({
        title: this.$t('imageLibrary.pickerTitle'),
        component: ImageLibrary,
        props: { modalClass: 'w-216', pickerMode: true },
        listeners: {
          select: (image) => this.onSelectImage(image),
        },
      })
    },
    removeImage() {
      this.$emit('input', null)
    },
    onSelectImage(image) {
      this.closeModal()
      this.$emit('input', { ...this.value, ...image })
      this.errorOnLoading = false
    },
  },
}
</script>
