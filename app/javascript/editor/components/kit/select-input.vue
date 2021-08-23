<template>
  <div>
    <label
      class="block font-semibold text-gray-800"
      :for="name"
      v-if="withLabel"
    >
      {{ label }}
    </label>
    <div class="relative">
      <button
        class="
          text-left
          block
          w-full
          mt-1
          py-2
          px-3
          rounded
          bg-gray-100
          text-gray-800
          focus:outline-none focus:ring
        "
        type="button"
        @click="toggle"
      >
        <div class="flex items-center" :class="buttonClass">
          <slot name="value" v-if="value"></slot>
          <span v-else>{{ placeholder }}</span>
          <button
            type="button"
            class="ml-auto"
            @click.stop.prevent="clear"
            v-if="canClear"
          >
            <icon name="ri-close-line" />
          </button>
          <icon
            name="arrow-up-s-line"
            size="1.5rem"
            :class="{ 'ml-1': canClear, 'ml-auto': !canClear }"
            v-if="isOpen"
          />
          <icon
            name="arrow-down-s-line"
            size="1.5rem"
            :class="{ 'ml-1': canClear, 'ml-auto': !canClear }"
            v-else
          />
        </div>
      </button>
      <div
        class="absolute w-full z-10 -mt-1 rounded-b shadow-sm bg-gray-100"
        @keydown="naviguate"
        v-if="isOpen"
      >
        <div class="px-3 pt-1 pb-3" v-if="searchEnabled">
          <input
            class="
              block
              mt-1
              px-3
              py-1
              w-full
              border
              rounded
              border-gray-300
              bg-gray-100
              placeholder-gray-500
              focus:ring focus:ring
            "
            type="text"
            v-model="q"
            :placeholder="searchPlaceholder"
            ref="input"
          />
        </div>

        <div class="px-4 pb-3 text-gray-600 text-sm" v-if="isEmpty">
          {{ emptyLabel }}
        </div>

        <div v-if="list">
          <div
            v-for="(item, index) in list"
            :key="item.id"
            class="py-1 px-4 cursor-pointer"
            :class="{
              'rounded-b': index === list.length - 1,
              'bg-editor-primary text-white': index === focus,
            }"
            @mouseover="focus = index"
            @mouseleave="focus = undefined"
            @click="select(item)"
          >
            <slot
              name="item"
              v-bind:item="item"
              v-bind:hovered="index === focus"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { debounce } from '@/utils'

export default {
  name: 'SelectInput',
  props: {
    label: { type: String, default: 'Label' },
    name: { type: String, default: 'text' },
    placeholder: { type: String, default: 'Select an item' },
    searchEnabled: { type: Boolean, default: false },
    searchPlaceholder: { type: String, default: 'Search...' },
    value: { type: Object, default: null },
    fetchList: { type: Function, default: () => ({}) },
    emptyLabel: { type: String, default: 'No results found' },
    clearEnabled: { type: Boolean, default: false },
    withLabel: { type: Boolean, default: true },
    buttonClass: { type: [Object, String], default: () => ({}) },
  },
  data() {
    return {
      isOpen: false,
      q: undefined,
      list: undefined,
      focus: undefined,
    }
  },
  created() {
    this.debouncedFetch = debounce(this.fetch.bind(this), 300)
  },
  computed: {
    canClear() {
      return this.clearEnabled && this.value
    },
    isEmpty() {
      return this.list && this.list.length === 0
    },
  },
  methods: {
    toggle() {
      this.isOpen = !this.isOpen
    },
    fetch() {
      this.fetchList(this.q).then((list) => {
        this.list = list
        this.focus = list && list.length > 0 ? 0 : null
      })
    },
    select(value) {
      this.$emit('input', value)
      this.reset()
    },
    clear() {
      this.$emit('input', null)
      this.reset()
    },
    naviguate(event) {
      if (!this) return
      switch (event.keyCode) {
        case 13:
          if (this.focus !== undefined) {
            this.select(this.list[this.focus])
          }
          event.stopPropagation() & event.preventDefault()
          break
        case 38:
          if (!this.focus) {
            this.focus = 0
          } else if (this.focus > 0) {
            this.focus--
          }
          event.stopPropagation() & event.preventDefault()
          break
        case 40:
          if (!this.focus) {
            this.focus = 0
          } else if (this.focus < this.list.length - 1) {
            this.focus++
          }
          event.stopPropagation() & event.preventDefault()
          break
      }
    },
    reset() {
      this.isOpen = false
      this.q = null
      this.list = undefined
      this.focus = undefined
    },
  },
  watch: {
    q() {
      if (!this.q) return
      this.debouncedFetch()
    },
    isOpen() {
      if (this.isOpen)
        this.$nextTick(() => {
          if (this.searchEnabled) this.$refs.input.focus()
          else this.debouncedFetch()
        })
    },
  },
}
</script>
