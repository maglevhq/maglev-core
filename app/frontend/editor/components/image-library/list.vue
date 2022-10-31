<template>
  <div class="grid grid-cols-4 gap-4">
    <list-item
      v-for="(image, index) in images"
      :key="image.id"
      :image="image"
      :leftEdge="index % 4 === 0"
      :bottomEdge="index >= Math.ceil(images.length / 4 - 1) * 4"
      :pickerMode="pickerMode"
      v-on="$listeners"
    />
  </div>
</template>

<script>
import ListItem from './list-item.vue'

export default {
  name: 'ImageLibraryList',
  components: { ListItem },
  props: {
    images: { type: Array, default: () => [] },
    pickerMode: { type: Boolean, required: true },
  },
}
</script>
