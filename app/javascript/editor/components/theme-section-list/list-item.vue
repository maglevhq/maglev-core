<template>
  <div 
    class="relative bg-gray-100 mb-3 w-full min-height transition duration-150 ease-in-out transform hover:-translate-y-1 cursor-pointer"     
    :class="{ 'h-16': !hasScreenshot }"
    @mouseover="hovered = true" @mouseleave="hovered = false"
    @click="select"
  >
    <img class="w-full" :src="section.screenshotPath" v-if="hasScreenshot" />
    <transition name="slide-up">
      <div 
        class="flex items-center px-2 absolute bg-black bg-opacity-75 bottom-0 h-8 w-full text-white text-xs cursor-default"
        v-if="hovered"
      >
        <p class="capitalize-first">{{ section.name }}</p>                  
      </div>    
    </transition>  
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  name: 'ThemeSectionListItem',
  props: {
    section: { type: Object, required: true, default: null },
  },
  data() {
    return { hovered: false }
  },
  computed: {
    hasScreenshot() {
      return this.section.screenshotPath
    }
  },
  methods: {
    ...mapActions(['addSection']),    
    select() {
      this.addSection(this.section).then(() => {
        this.$router.push({ name: 'editPage' })
      })
    }
  }
}
</script>

<style scoped>
  .min-height {
    min-height: theme('spacing.16');
  }
</style>
