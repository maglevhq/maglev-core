<template>
  <div class="w-full">
    <uikit-dropdown
      placement="left"
      ref="dropdown"
      :fullWidth="true"
      v-on="$listeners"
      v-if="hasMultipleTypes"
    >
      <template v-slot:button>
        <uikit-icon-button iconName="ri-add-line" />
      </template>
      <template v-slot:content>
        <div class="w-full flex flex-col">
          <button
            v-for="blockType in blockTypes"
            :key="blockType.type"
            class="mb-2 text-base text-gray-900 py-2 px-4 hover:bg-gray-100 transition-colors"
            @click="addNestedSectionBlockAndClose(blockType.type)"
          >
            {{ blockType.name }}
          </button>
        </div>
      </template>
    </uikit-dropdown>
    <uikit-icon-button
      iconName="ri-add-line"
      @click.native="addNestedSectionBlock"
      v-else
    />
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  name: 'NewNestedSectionBlockButton',
  props: {
    parentId: { type: String, required: true },
    accept: { type: Array, required: true },
  },
  computed: {
    hasMultipleTypes() {
      return this.blockTypes.length > 1
    },
    blockTypes() {
      return this.currentSectionDefinition.blocks.filter(
        (block) => this.accept.indexOf(block.type) !== -1,
      )
    },
  },
  methods: {
    ...mapActions(['addSectionBlock']),
    addNestedSectionBlock() {
      this.addSectionBlock({
        blockType: this.blockTypes[0].type,
        parentId: this.parentId,
      })
    },
    addNestedSectionBlockAndClose(blockType) {
      this.addSectionBlock({ blockType, parentId: this.parentId })
      this.$refs.dropdown.close()
    },
  },
}
</script>
