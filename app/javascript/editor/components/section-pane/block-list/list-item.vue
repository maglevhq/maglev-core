<template>
  <div
    class="bg-gray-100 rounded-md px-4 py-3 flex items-center justify-between text-gray-800"
    :class="{ 'cursor-move': isList }"
  >
    <router-link
      :to="{
        name: 'editSectionBlock',
        params: { sectionBlockId: sectionBlock.id },
      }"
      class="flex items-center"
    >
      <div class="h-8 w-8 bg-gray-400 mr-3" v-if="image">
        <img
          :src="image"
          class="object-cover w-full h-full"
          :class="{ hidden: !imageLoaded }"
          @load="() => (imageLoaded = true)"
        />
      </div>
      <span>{{ label | truncate(40) }}</span>
    </router-link>
    <div class="flex items-center">
      <slot name="actions"></slot>
      <confirmation-button
        @confirm="removeSectionBlock(sectionBlock.id)"
        v-on="$listeners"
      >
        <list-item-button iconName="ri-close-line" />
      </confirmation-button>
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
        this.sectionBlock, this.index + 1
      )
      return { label: label[0], image: label[1] }
    },
    label() {
      return this.presentation.label
    },
    image() {
      return this.presentation.image
    }
  },
  methods: {
    ...mapActions(['removeSectionBlock']),
  },
}
</script>
