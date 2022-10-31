<template>
  <div class="flex flex-col h-full">
    <div class="relative flex-auto h-0 overflow-y-auto">
      <transition-group type="transition" name="flip-list">
        <tree-node
          v-for="(treeNode, index) in treeData"
          :key="treeNode.sectionBlock.id"
          :treeNode="treeNode"
          :siblings="treeData"
          :depth="0"
          :index="index"
          :last="index === treeData.length - 1"
          @on-dropdown-toggle="onDropdownToggle"
          @change="change"
          class="mb-3"
        />
      </transition-group>
    </div>
    <div class="mt-auto relative">
      <new-block-button @on-dropdown-toggle="onDropdownToggle" />
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import GroupedDropdownsMixin from '@/mixins/grouped-dropdowns'
import TreeNode from './tree-node.vue'
import NewBlockButton from '../block-list/new-block-button.vue'

export default {
  name: 'SectionBlockTree',
  mixins: [GroupedDropdownsMixin],
  components: { TreeNode, NewBlockButton },
  data() {
    return { treeData: null }
  },
  methods: {
    ...mapActions(['sortSectionBlocks']),
    change() {
      const list = this.services.block.decodeTree(this.treeData)
      this.sortSectionBlocks(list)
    },
  },
  watch: {
    currentSectionBlocks: {
      immediate: true,
      handler() {
        this.treeData = this.services.block.encodeToTree(
          this.currentSectionBlocks,
        )
      },
    },
  },
}
</script>

<style scoped>
.flip-list-move {
  @apply transition-transform;
  @apply duration-300;
}
</style>
