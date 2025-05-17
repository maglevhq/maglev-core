<template>
  <div :style="{ 'margin-left': marginLeft }">
    <list-item
      :sectionBlock="treeNode.sectionBlock"
      :index="index"
      v-on="$listeners"
    >
      <template v-slot:actions>
        <div class="flex items-center">
          <new-nested-block-button
            :parentId="treeNode.sectionBlock.id"
            :accept="acceptedNestedSectionBlocks"
            v-if="canAdd"
            v-on="$listeners"
          />

          <uikit-icon-button
            iconName="arrow-up-s-line"
            @click.native="moveSectionBlockUp"
            v-if="index > 0"
          />

          <uikit-icon-button
            iconName="arrow-down-s-line"
            @click.native="moveSectionBlockDown"
            v-if="!last"
          />
        </div>
      </template>
    </list-item>

    <div class="mt-3" v-if="hasChildren">
      <transition-group type="transition" name="flip-list">
        <block-tree-node
          v-for="(childNode, index) in children"
          :key="childNode.sectionBlock.id"
          :treeNode="childNode"
          :siblings="children"
          :depth="depth + 1"
          :index="index"
          :last="index === children.length - 1"
          class="mb-3"
          v-on="$listeners"
        />
      </transition-group>
    </div>
  </div>
</template>

<script>
import ListItem from '../block-list/list-item.vue'
import NewNestedBlockButton from './new-nested-block-button.vue'

export default {
  name: 'BlockTreeNode',
  components: { ListItem, NewNestedBlockButton },
  props: {
    treeNode: { type: Object, required: true },
    siblings: { type: Array },
    depth: { type: Number, required: true },
    index: { type: Number, required: true },
    last: { type: Boolean, required: false, default: false },
  },
  computed: {
    children() {
      return this.treeNode.children
    },
    hasChildren() {
      return this.children?.length > 0
    },
    sectionBlockDefinition() {
      return this.currentSectionDefinition.blocks.find(
        (block) => block.type === this.treeNode.sectionBlock.type,
      )
    },
    acceptedNestedSectionBlocks() {
      return this.sectionBlockDefinition?.accept
    },
    canAdd() {
      return this.acceptedNestedSectionBlocks?.length > 0
    },
    marginLeft() {
      return `${this.depth * 1.25}rem`
    },
  },
  methods: {
    moveSectionBlockUp() {
      this.swapSectionBlockWith(this.index - 1)
    },
    moveSectionBlockDown() {
      this.swapSectionBlockWith(this.index + 1)
    },
    swapSectionBlockWith(newIndex) {
      ;[this.siblings[this.index], this.siblings[newIndex]] = [
        this.siblings[newIndex],
        this.siblings[this.index],
      ]
      this.$emit('change')
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
