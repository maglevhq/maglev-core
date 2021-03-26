<template>
  <div>
    <draggable v-model="list" v-bind="dragOptions">
      <transition-group type="transition" name="flip-list">
        <list-item
          v-for="(sectionBlock, index) in currentSectionBlocks" 
          :key="sectionBlock.id" 
          :sectionBlock="sectionBlock"
          :index="index"
          class="mb-2"
        />        
      </transition-group>
    </draggable>  

    <div class="mt-2">
      <new-block-button />
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import draggable from 'vuedraggable'
import ListItem from './list-item'
import NewBlockButton from './new-block-button'

export default {
  name: 'SectionBlockList',
  components: { draggable, ListItem, NewBlockButton },
  computed: {
    list: {
      get() {
        return this.currentSection.blocks // NOTE: blocks holds only ids
      },
      set(value) {
        this.sortSectionBlocks(value)
      }
    },
    dragOptions() {
      return {
        animation: 0,
        group: 'description',
        disabled: false,
        ghostClass: 'ghost'
      }
    }
  },
  methods: {
    ...mapActions(['sortSectionBlocks']),
  },
}
</script>

<style scoped>
  .flip-list-move {
    @apply transition-transform;
    @apply duration-300;
  }
  .ghost {
    @apply opacity-50;
  }
</style>
