<script setup>
import { computed, defineAsyncComponent } from 'vue'

const props = defineProps({
  name: { type: String },
  size: { type: String, default: '1.25rem' },
  spin: { type: Boolean, default: false },
  bounce: { type: Boolean, default: false },
  library: { type: String, default: 'remixicons' },
})

const icon = computed(() => {
  return defineAsyncComponent(() =>
    import(`../../assets/${props.library}/${props.name}.svg`),
  )
})
</script>

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
