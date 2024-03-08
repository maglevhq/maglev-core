<template>
  <div>
    <div class="block font-semibold text-gray-800" @click="focus()">
      {{ label }}
    </div>
    <div class="mt-1">
      <div
        class="flex items-center justify-center bg-gray-100 h-24 rounded"
        v-if="isBlank(value)"
      >
        <button
          class="flex items-center justify-center flex-col"
          @click="openIconPickerModal"
        >
          <uikit-icon name="ri-book-line" />
          <p class="uppercase text-xs mt-1">{{ $t('iconInput.addButton') }}</p>
        </button>
      </div>
      <div v-else>
        <div
          class="relative bg-gray-100 h-24 rounded flex items-center justify-center overflow-hidden"
          @mouseover="hovered = true"
          @mouseleave="hovered = false"
        >
          <i class="text-6xl text-gray-800 font-bold" :class="value" />
          <transition name="slide-up">
            <div
              class="flex justify-center py-3 px-2 absolute bg-black bg-opacity-75 bottom-0 w-full text-white cursor-default rounded-b"
              v-if="hovered"
            >
              <button
                class="flex items-center justify-center flex-col mr-4"
                @click="openIconPickerModal"
              >
                <uikit-icon name="ri-book-line" />
                <p class="uppercase text-xs mt-1">
                  {{ $t('iconInput.replaceButton') }}
                </p>
              </button>

              <button
                class="flex items-center justify-center flex-col"
                @click="removeIcon"
              >
                <uikit-icon name="delete-bin-line" />
                <p class="uppercase text-xs mt-1">
                  {{ $t('iconInput.clearButton') }}
                </p>
              </button>
            </div>
          </transition>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import FocusedInputMixin from '@/mixins/focused-input'
import IconLibrary from '@/components/icon-library/index.vue'

export default {
  name: 'UIKitIconInput',
  mixins: [FocusedInputMixin],
  props: {
    label: { type: String, default: 'Label' },
    name: { type: String, default: 'icon' },
    value: { default: () => ({ altText: '' }) },
  },
  data() {
    return { hovered: false, errorOnLoading: false }
  },
  methods: {
    focus() {
      this.openIconPickerModal()
    },
    openIconPickerModal() {
      this.openModal({
        title: this.$t('iconLibrary.pickerTitle'),
        component: IconLibrary,
        props: { modalClass: 'w-120', pickerMode: true },
        listeners: {
          select: (icon) => this.onSelectIcon(icon),
        },
      })
    },
    removeIcon() {
      this.$emit('input', null)
    },
    onSelectIcon(icon) {
      this.closeModal()
      this.$emit('input', icon)
    },
  },
}
</script>
