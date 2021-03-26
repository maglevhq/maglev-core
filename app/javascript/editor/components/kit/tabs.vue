<template>
  <div class="flex flex-col h-full">
    <nav class="flex flex-col sm:flex-row" :class="sharedClass">
      <button 
        v-for="(tab, index) in tabs" 
        :key="`tab-${index}`"
        type="button"
        class="text-gray-500 py-1 pb-0 px-4 block hover:text-editor-primary focus:outline-none border-b-2 border-transparent z-10"
        :class="{ 'text-editor-primary font-medium border-editor-primary': index === currentIndex }"
        @click="selectTab(index)"
      >
        {{ tab.name }}
      </button>
    </nav>
    <div class="relative -mt-1/2" :class="sharedClass">
      <div class="w-full border-gray-200 border-t-2 h-0"></div>
    </div>
    <div class="flex-1 overflow-y-auto mt-4 pb-4" :class="sharedClass">        
      <transition :name="slideDirection" mode="out-in">        
        <component :is="currentTabComponent" v-on="$listeners" v-bind="{...otherProps}" />
      </transition>
    </div>  
  </div>
</template>

<script>
export default {
  name: 'Tabs',
  props: {
    tabs: { type: Array, default: () => ([]) },
    firstIndex: { type: Number, default: 0 },
    otherProps: { type: Object, default: () => ({}) },
    sharedClass: { type: [String, Object], default: () => ({}) },
  },
  data() {
    return { currentIndex: 0, slideDirection: null }
  },
  computed: {
    currentTabComponent() {
      return this.tabs[this.currentIndex].tab
    },    
  },
  methods: {
    selectTab(index) {
      this.currentIndex = index
    }
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
    }
  }
}
</script>
