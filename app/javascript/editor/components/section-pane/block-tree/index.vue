<template>
  <div>
    <Tree :value="treeData" @change="change" v-if="treeData">
      <div slot-scope="{node, index}">
        <list-item
          :sectionBlock="node.sectionBlock"
          :key="node.sectionBlock.id"
          :index="index"
          @on-dropdown-toggle="onDropdownToggle"
          class="mb-3"
        />    
      </div>
    </Tree>

    <div class="mt-2">
      <new-block-button />
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import { Tree, Draggable, cloneTreeData, getPureTreeData } from 'he-tree-vue'
import GroupedDropdownsMixin from '@/mixins/grouped-dropdowns'
import ListItem from '../block-list/list-item'
import NewBlockButton from '../block-list/new-block-button'

export default {
  name: 'SectionBlockTree',
  mixins: [GroupedDropdownsMixin],
  components: { Tree: Tree.mixPlugins([Draggable]), ListItem, NewBlockButton },
  data() {
    return { treeData: null }
  },
  methods: {
    ...mapActions(['sortSectionBlocks']),
    change() {
      const list = this.services.block.decodeTree(getPureTreeData(this.treeData))
      this.sortSectionBlocks(list)
    },
  },
  watch: {
    currentSectionBlocks: {
      immediate: true,
      handler() {
        this.treeData = cloneTreeData(this.services.block.encodeToTree(this.currentSectionBlocks))
      }
    }
  }
}
</script>


