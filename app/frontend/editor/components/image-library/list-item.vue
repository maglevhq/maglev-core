<template>
  <div
    class="col-span-1"
    @mouseover="hovered = true"
    @mouseleave="hovered = false"
  >
    <div class="bg-checkerboard pb-full relative overflow-hidden rounded">
      <div class="absolute inset-0 h-full w-full rounded">
        <img
          class="h-full w-full object-contain"
          :class="{
            'cursor-pointer': pickerMode,
          }"
          :src="image.url"
          @click.prevent="$emit('select', image)"
        />
        <transition name="slide-up">
          <div
            class="flex items-center px-2 absolute bg-black bg-opacity-75 bottom-0 h-12 w-full text-white text-xs cursor-default rounded-b"
            v-if="actionBarDisplayed"
          >
            <button
              type="button"
              class="px-1 py-1 bg-white rounded-full flex items-center justify-center text-gray-900 ml-auto"
              @click="() => (this.askingForRemoval = true)"
            >
              <uikit-icon name="delete-bin-line" size="1rem" />
            </button>
          </div>
        </transition>
        <div
          class="flex items-center justify-center absolute bg-black bg-opacity-75 inset-0 rounded text-white"
          v-if="askingForRemoval"
        >
          <div class="text-center">
            <p class="mb-2">{{ $t('imageLibrary.destroy.text') }}</p>
            <button
              class="block w-full rounded text-center text-sm bg-transparent py-1 px-4 hover:bg-white hover:text-gray-900"
              @click="() => $emit('destroy', this.image)"
            >
              {{ $t('imageLibrary.destroy.ok') }}
            </button>
            <button
              class="block w-full rounded text-center text-sm bg-transparent py-1 px-4 hover:bg-white hover:text-gray-900"
              @click="() => (this.askingForRemoval = false)"
            >
              {{ $t('imageLibrary.destroy.cancel') }}
            </button>
          </div>
        </div>
      </div>
    </div>
    <div class="mt-1 px-2 text-xs font-bold text-gray-900">
      {{ image.filename | truncate(26) }}
    </div>
    <div
      class="px-2 mb-1 flex items-center text-xs justify-between text-gray-700"
    >
      <span :class="{ invisible: !hasDimensions }"
        >{{ image.width }}x{{ image.height }}</span
      >
      <span :class="{ invisible: !hasSize }">{{
        image.byteSize | numberToHumanSize
      }}</span>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ImageLibraryListItem',
  props: {
    image: { type: Object, required: true },
    leftEdge: { type: Boolean, default: false },
    bottomEdge: { type: Boolean, default: false },
    pickerMode: { type: Boolean, required: true },
  },
  data() {
    return { hovered: false, askingForRemoval: false }
  },
  computed: {
    hasDimensions() {
      return !this.isBlank(this.image.width) && !this.isBlank(this.image.height)
    },
    hasSize() {
      return !this.isBlank(this.image.byteSize)
    },
    actionBarDisplayed() {
      return this.hovered && !this.askingForRemoval
    },
  },
}
</script>
