<template>
  <div>
    <div class="block font-semibold text-gray-800" @click="focus()">
      {{ label }}
    </div>

    <uikit-text-input
      :name="name"
      v-model="textInput"
      :showLabel="false"
      :placeholder="$t('linkInput.nestedTextPlaceholder')"
      :isFocused="isFocused"
      class="mt-2"
      :class="{ hidden: !withText }"
    />

    <div
      class="flex items-center w-full mt-2 py-3 px-3 rounded bg-gray-100 text-gray-800 cursor-pointer"
      @click="openLinkPickerModal"
    >
      <div class="flex-1 flex items-center overflow-hidden" v-if="isPage">
        <uikit-page-icon :page="{ path: value.href }" class="flex-shrink-0" />
        <span class="ml-3">{{ value.linkLabel }}</span>
      </div>
      <div class="flex-1 flex items-center overflow-hidden" v-if="isUrl">
        <uikit-icon name="ri-external-link-line" class="flex-shrink-0" />
        <span class="ml-3 shrink">{{ value.href }}</span>
      </div>
      <div class="flex-1 flex items-center overflow-hidden" v-if="isEmail">
        <uikit-icon name="ri-mail-line" class="flex-shrink-0" />
        <span class="ml-3">{{ value.email }}</span>
      </div>

      <div
        class="flex-1 flex items-center overflow-hidden text-gray-400"
        v-if="isBlank(value)"
      >
        {{ $t('linkInput.placeholder') }}
      </div>

      <button class="ml-3" @click.prevent.stop="clear" v-if="!isBlank(value)">
        <uikit-icon name="ri-close-line" />
      </button>
    </div>
  </div>
</template>

<script>
import LinkPicker from '@/components/link-picker/index.vue'
import { pick } from '@/misc/utils'

export default {
  name: 'UIKitLinkInput',
  props: {
    label: { type: String, default: 'Label' },
    name: { type: String, default: 'image' },
    withText: { type: Boolean, default: false },
    value: { default: () => ({ text: '' }) },
    isFocused: { type: Boolean, default: false },
  },
  computed: {
    isPage() {
      return (
        this.value?.linkType === 'page' ||
        this.value?.linkType === 'static_page'
      )
    },
    isUrl() {
      return (
        (this.value && !this.value.linkType) || this.value?.linkType === 'url'
      )
    },
    isEmail() {
      return this.value?.linkType === 'email'
    },
    textInput: {
      get() {
        return this.value?.text
      },
      set(text) {
        this.$emit('input', { ...this.value, text })
      },
    },
  },
  methods: {
    focus() {
      this.openLinkPickerModal()
    },
    setLink(link) {
      this.$emit('input', {
        ...pick(
          link,
          'linkType',
          'linkLabel',
          'linkId',
          'sectionId',
          'href',
          'email',
          'openNewWindow',
          'text',
        ),
        text: this.value?.text || '',
      })
      this.closeModal()
    },
    clear() {
      this.$emit('input', null)
    },
    openLinkPickerModal() {
      this.openModal({
        title: this.$t('linkPicker.title'),
        component: LinkPicker,
        props: { currentLink: this.value, modalClass: 'h-144 w-120' },
        listeners: {
          select: (link) => this.setLink(link),
        },
      })
    },
  },
}
</script>
