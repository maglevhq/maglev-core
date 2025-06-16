<template>
  <div class="flex flex-col h-full">
    <div class="relative flex-auto h-0 overflow-y-auto pt-2">
      <draggable v-model="list" v-bind="dragOptions">
        <transition-group type="transition" name="flip-list">
          <list-item
            v-for="(sectionBlock, index) in currentSectionBlocks"
            :key="sectionBlock.id"
            :sectionBlock="sectionBlock"
            :index="index"
            @on-dropdown-toggle="onDropdownToggle"
            class="mb-4"
          />
        </transition-group>
      </draggable>
    </div>

    <div class="mt-auto relative">
      <new-block-button @on-dropdown-toggle="onDropdownToggle" />
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import draggable from 'vuedraggable'
import GroupedDropdownsMixin from '@/mixins/grouped-dropdowns'
import ListItem from './list-item.vue'
import NewBlockButton from './new-block-button.vue'

export default {
  name: 'SectionBlockList',
  mixins: [GroupedDropdownsMixin],
  components: { draggable, ListItem, NewBlockButton },
  computed: {
    list: {
      get() {
        return this.currentSectionBlocks
      },
      set(value) {
        this.sortSectionBlocks(value)
      },
    },
    dragOptions() {
      return {
        animation: 0,
        group: 'description',
        disabled: false,
        ghostClass: 'ghost',
        handle: '.cursor-move',
      }
    },
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
