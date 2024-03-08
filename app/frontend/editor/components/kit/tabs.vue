<template>
  <div
    class="flex flex-col flex-1"
    :class="{ 'overflow-y-hidden': enableOverflow }"
  >
    <nav class="flex flex-col sm:flex-row" :class="{
      [sharedClass]: !isBlank(sharedClass),
      [navClass]: !isBlank(navClass)
    }">
      <button
        v-for="(tab, index) in tabs"
        :key="`tab-${index}`"
        type="button"
        class="py-1 pb-0 px-4 block hover:text-editor-primary focus:outline-none border-b-2 z-10"
        :class="{
          'text-gray-500 border-transparent': index !== currentIndex,
          'text-editor-primary font-medium border-editor-primary':
            index === currentIndex,
        }"
        @click="selectTab(index)"
      >
        {{ tab.name }}
      </button>
    </nav>
    <div class="relative -mt-1/2" :class="{
      [sharedClass]: !isBlank(sharedClass),
      [navClass]: !isBlank(navClass)
    }">
      <div class="w-full border-gray-200 border-t-2 h-0"></div>
    </div>
    <div
      class="flex-1 mt-4 pb-4"
      :class="{
        [sharedClass]: !isBlank(sharedClass),
        [panelClass]: !isBlank(panelClass),
        'overflow-y-auto': enableOverflow,
      }"
    >
      <transition :name="slideDirection" mode="out-in">
        <component
          :is="currentTabComponent"
          :key="currentTabKey"
          v-on="$listeners"
          v-bind="{ ...otherProps, ...currentTabProps }"
          class="px-1"
        />
      </transition>
    </div>
  </div>
</template>

<script>
export default {
  name: 'UIKitTabs',
  props: {
    tabs: { type: Array, default: () => [] },
    firstIndex: { type: Number, default: 0 },
    otherProps: { type: Object, default: () => ({}) },
    navClass: { type: String, default: null },
    panelClass: { type: String, default: null },
    sharedClass: { type: String, default: null },
    enableOverflow: { type: Boolean, default: true },
  },
  data() {
    return { currentIndex: 0, slideDirection: null }
  },
  computed: {
    currentTab() {
      return this.tabs[this.currentIndex]
    },
    currentTabComponent() {
      return this.currentTab.tab
    },
    currentTabKey() {
      return this.currentTab.type
    },
    currentTabProps() {
      return this.currentTab.props ? this.currentTab.props() : {}
    },
  },
  methods: {
    selectTab(index) {
      this.currentIndex = index
      this.$emit('select-tab', index)
    },
  },
  watch: {
    firstIndex: {
      immediate: true,
      handler() {
        this.currentIndex = this.firstIndex
      },
    },
    currentIndex(newIndex, oldIndex) {
      this.slideDirection = newIndex > oldIndex ? 'slide-left' : 'slide-right'
    },
  },
}
</script>
