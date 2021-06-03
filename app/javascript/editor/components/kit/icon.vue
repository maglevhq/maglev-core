<template>
  <component 
    v-bind:is="icon" 
    viewBox="0 0 24 24" 
    :width="size" 
    :height="size" 
    class="fill-current"
    :class="{ 'animate-spin': spin, 'animate-bounce': bounce }"
  ></component>  
</template>

<script>
// RemixIcon (https://remixicon.com)
const icons = {
  remixicons: require.context('@/assets/remixicons', true),
  zondicons: require.context('@/assets/zondicons', true)
}

export default {
  name: 'MaglevIcon',
  props: {
    name: { type: String },
    size: { type: String, default: '1.25rem' },
    spin: { type: Boolean, default: false },
    bounce: { type: Boolean, default: false },
    library: { type: String, default: 'remixicons' }
  },
  computed: {
    icon() {      
      return icons[this.library](`./${this.name}.svg`, true).default
    }
  }
}
</script>
