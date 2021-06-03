<template>
  <div 
    class="bg-gray-100 rounded-md px-4 py-3 flex items-center justify-between text-gray-800"          
  >
    <router-link 
      :to="{ name: 'editSectionBlock', params: { sectionBlockId: sectionBlock.id } }" 
      class="flex items-center"
    >
      <div class="h-8 w-8 bg-gray-400 mr-3" v-if="image">
        <img 
          :src="image" 
          class="object-cover w-full h-full" 
          :class="{ 'hidden': !imageLoaded }" 
          @load="() => imageLoaded = true"
        />  
      </div>    
      <span>{{ label | truncate(40) }}</span>
    </router-link>    
    <confirmation-button @confirm="removeSectionBlock(index)" v-on="$listeners">
      <button 
        class="px-1 py-1 rounded-full bg-gray-600 bg-opacity-0 hover:text-gray-900 text-gray-600 focus:outline-none hover:bg-opacity-10 transition-colors duration-200"
      >
        <icon name="ri-close-line" size="1.25rem" />
      </button>
    </confirmation-button>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  name: 'SectionBlockListItem',
  props: {
    sectionBlock: { type: Object, required: true },
    index: { type: Number, required: true },
  },
  data() {
    const [label, image] = this.$store.getters.sectionBlockLabel(this.sectionBlock)
    return { 
      label: label || this.$t('sectionPane.blockList.defaultLabel', { index: this.index + 1 }), 
      image, 
      imageLoaded: false 
    }
  },  
  methods: {
    ...mapActions(['removeSectionBlock']),
  },  
}
</script>
