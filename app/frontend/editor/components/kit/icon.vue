<template>
  <component
    v-bind:is="icon"
    v-bind="$attrs"
    viewBox="0 0 24 24"
    class="fill-current"
    :class="{ 'animate-spin': spin, 'animate-bounce': bounce }"
    :style="{ width: size, height: size }"
  ></component>
</template>

<script>
import { defineAsyncComponent } from 'vue'

export default {
  name: 'UIKitIcon',
  props: {
    name: { type: String },
    size: { type: String, default: '1.25rem' },
    spin: { type: Boolean, default: false },
    bounce: { type: Boolean, default: false },
    library: { type: String, default: 'remixicons' },
  },
  data() {
    return {
      icons: import.meta.glob(`../../assets/**/*.svg`),
    }
  },
  computed: {
    icon() {
      const path = `../../assets/${this.library}/${this.name}.svg`
      return defineAsyncComponent(() => this.icons[path]())      
    },
  },
}
</script>
