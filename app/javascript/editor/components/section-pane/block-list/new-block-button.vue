<template>
  <div class="w-full">
    <dropdown placement="left" ref="dropdown" :fullWidth="true" v-if="hasMultipleTypes">
      <template v-slot:button>
        <button 
          class="border-purple-200 text-purple-200 hover:border-editor-primary hover:text-editor-primary transition-all duration-200 ease-in-out border-dashed border-2 rounded-md w-full px-4 py-3 flex items-center w-full"
        >
          <icon name="ri-add-line" size="1.5rem" />
          <span class="ml-3">{{ $t('sectionPane.blockList.add') }}</span>
        </button>
      </template>
      <template v-slot:content>
        <div class="w-full flex flex-col">
          <button 
            v-for="blockType in blockTypes" 
            :key="blockType.type"
            class="mb-2 text-base text-gray-900 py-2 hover:underline hover:text-black"
            @click="addSectionBlockAndClose(blockType.type)" 
          >
            {{ blockType.name }}
          </button>
        </div>
      </template>
    </dropdown>
    <button 
      class="border-purple-200 text-purple-200 hover:border-editor-primary hover:text-editor-primary transition-all duration-200 ease-in-out border-dashed border-2 rounded-md w-full px-4 py-3 flex items-center"
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
      return this.currentSectionDefinition.blocks
    }
  },
  methods: {
    ...mapActions(['addSectionBlock']),
    addSectionBlockAndClose(blockType) {
      this.addSectionBlock(blockType)
      this.$refs.dropdown.close()
    }
  },
}
</script>
