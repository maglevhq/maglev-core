<template>
  <component
    v-bind:is="icon"
    v-bind="$attrs"
    viewBox="0 0 24 24"
    :width="size"
    :height="size"
    class="fill-current"
    :class="{ 'animate-spin': spin, 'animate-bounce': bounce }"
  ></component>
</template>

<script>
import { defineAsyncComponent } from 'vue'

export default {
  name: 'MaglevIcon',
  props: {
    name: { type: String },
    size: { type: String, default: '1.25rem' },
    spin: { type: Boolean, default: false },
    bounce: { type: Boolean, default: false },
    library: { type: String, default: 'remixicons' },
  },
  computed: {
    iconPath() {
      return `../../assets/${this.library}/${this.name}.svg`
    },
    icon() {
      return defineAsyncComponent(() => import(this.iconPath))
    },
  },
}
</script>
