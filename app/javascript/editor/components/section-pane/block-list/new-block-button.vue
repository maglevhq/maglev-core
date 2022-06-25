<template>
  <div class="w-full button-wrapper">
    <dropdown
      ref="dropdown"
      placement="top"
      v-on="$listeners"
      v-if="hasMultipleTypes"
    >
      <template v-slot:button>
        <button class="big-submit-button bg-editor-primary">
          <icon name="ri-add-line" size="1.5rem" />
          <span class="ml-3">{{ $t('sectionPane.blockList.add') }}</span>
        </button>
      </template>
      <template v-slot:content>
        <div class="w-full flex flex-col">
          <button
            v-for="blockType in blockTypes"
            :key="blockType.type"
            class="mb-2 text-base text-gray-900 py-2 px-14 hover:bg-gray-100 transition-colors"
            @click="addSectionBlockAndClose(blockType.type)"
          >
            {{ blockType.name }}
          </button>
        </div>
      </template>
    </dropdown>
    <button
      class="big-submit-button bg-editor-primary"
      @click="addSectionBlock"
      v-else
    >
      <icon name="ri-add-line" size="1.5rem" />
      <span class="ml-3">{{ $t('sectionPane.blockList.add') }}</span>
    </button>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  name: 'NewSectionBlockButton',
  computed: {
    hasMultipleTypes() {
      return this.blockTypes.length > 1
    },
    blockTypes() {
      if (this.currentSectionDefinition.blocksPresentation === 'tree')
        return this.currentSectionDefinition.blocks.filter(
          (block) => block.root,
        )
      else return this.currentSectionDefinition.blocks
    },
  },
  methods: {
    ...mapActions(['addSectionBlock']),
    addSectionBlockAndClose(blockType) {
      this.addSectionBlock({ blockType })
      this.$refs.dropdown.close()
    },
  },
}
</script>

<style scoped>
.button-wrapper >>> .trigger {
  @apply w-full;
}
</style>
