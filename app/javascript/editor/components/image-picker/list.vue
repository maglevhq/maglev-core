<template>
  <div class="grid grid-cols-4 gap-2">
    <list-item
      v-for="(image, index) in images"
      :key="image.id"  
      :image="image"
      :leftEdge="index % 4 === 0"
      :bottomEdge="index >= (Math.ceil((images.length / 4) - 1) * 4)"
      v-on="$listeners"
    />    
  </div>
</template>

<script>
import ListItem from './list-item'

export default {
  name: 'ImagePickerList',
  components: { ListItem },
  props: {
    images: { type: Array, default: () => [] }
  },  
}
</script>
