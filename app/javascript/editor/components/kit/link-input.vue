<template>
  <div>
    <label class="block font-semibold text-gray-800" :for="name">
      {{ label }}
    </label>

    <text-input
      v-model="textInput"
      :showLabel="false"
      :placeholder="$t('linkInput.nestedTextPlaceholder')"
      class="mt-2"
      :class="{ hidden: !withText }"
    />

    <div
      class="
        flex
        items-center
        w-full
        mt-2
        py-3
        px-3
        rounded
        bg-gray-100
        text-gray-800
        cursor-pointer
      "
      @click="openLinkPickerModal"
    >
      <div class="flex items-center pr-6" v-if="isPage">
        <page-icon :page="{ path: value.href }" />
        <span class="ml-3">{{ value.linkLabel }}</span>
      </div>
      <div class="flex items-center pr-6" v-if="isUrl">
        <icon name="ri-external-link-line" />
        <span class="ml-3">{{ value.href }}</span>
      </div>
      <div class="flex items-center pr-6" v-if="isEmail">
        <icon name="ri-mail-line" />
        <span class="ml-3">{{ value.email }}</span>
      </div>

      <div class="pr-6 text-gray-400" v-if="isBlank(value)">
        {{ $t('linkInput.placeholder') }}
      </div>

      <button
        class="ml-auto"
        @click.prevent.stop="clear"
        v-if="!isBlank(value)"
      >
        <icon name="ri-close-line" />
      </button>
    </div>
    <!--    <LinkTextContent :value="value" />-->
  </div>
</template>

<script>
import LinkPicker from '@/components/link-picker'
import { pick } from '@/utils'

export default {
  name: 'LinkInput',
  props: {
    label: { type: String, default: 'Label' },
    name: { type: String, default: 'image' },
    withText: { type: Boolean, default: false },
    value: { default: () => ({ text: '' }) },
  },
  computed: {
    isPage() {
      return this.value?.linkType === 'page'
    },
    isUrl() {
      return this.value?.linkType === 'url'
    },
    isEmail() {
      return this.value?.linkType === 'email'
    },
    textInput: {
      get() {
        return this.value.text
      },
      set(text) {
        this.$emit('input', { ...this.value, text })
      },
    },
  },
  methods: {
    setLink(link) {
      this.$emit(
        'input',
        pick(
          link,
          'linkType',
          'linkLabel',
          'linkId',
          'sectionId',
          'href',
          'email',
          'openNewWindow',
          'withText',
          'text',
        ),
      )
      this.closeModal()
    },
    clear() {
      this.$emit('input', null)
    },
    openLinkPickerModal() {
      this.openModal({
        title: this.$t('linkPicker.title'),
        component: LinkPicker,
        props: { currentLink: this.value },
        listeners: {
          select: link => this.setLink(link),
        },
      })
    },
  },
}
</script>
