<template>
  <div
    class="bg-gray-100 rounded-md pr-2 flex items-center text-gray-800"
    :class="{ 'pl-4': !isList }"
  >
    <div class="flex flex-col cursor-move px-2 py-3" v-if="isList">
      <uikit-icon name="ri-draggable" />
    </div>
    <router-link
      :to="{
        name: 'editSectionBlock',
        params: { sectionBlockId: sectionBlock.id },
      }"
      class="flex items-center py-3 overflow-hidden"
    >
      <div class="h-8 w-8 bg-gray-400 mr-3" v-if="image">
        <img
          :src="image"
          class="object-cover w-full h-full"
          :class="{ hidden: !imageLoaded }"
          @load="() => (imageLoaded = true)"
        />
      </div>
      <span class="truncate">{{ label | truncate(40) }}</span>
    </router-link>
    <div class="flex items-center ml-auto pl-2">
      <slot name="actions"></slot>
      <uikit-confirmation-button
        @confirm="removeSectionBlock(sectionBlock.id)"
        v-on="$listeners"
      >
        <uikit-icon-button iconName="delete-bin-line" />
      </uikit-confirmation-button>
    </div>
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
    return {
      imageLoaded: false,
    }
  },
  computed: {
    isList() {
      return this.currentSectionDefinition.blocksPresentation !== 'tree'
    },
    presentation() {
      const label = this.$store.getters.sectionBlockLabel(
        this.sectionBlock,
        this.index + 1,
      )
      return { label: label[0], image: label[1] }
    },
    label() {
      return this.presentation.label
    },
    image() {
      return this.presentation.image
    },
  },
  methods: {
    ...mapActions(['removeSectionBlock']),
  },
}
</script>
