<template>
  <div
    class="
      bg-gray-100
      rounded-md
      px-4
      py-3
      flex
      items-center
      justify-between
      text-gray-800
    "
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
    const [label, image] = this.$store.getters.sectionBlockLabel(
      this.sectionBlock,
    )
    return {
      label:
        label ||
        this.$t('sectionPane.blockList.defaultLabel', {
          index: this.index + 1,
        }),
      image,
      imageLoaded: false,
    }
  },
  methods: {
    ...mapActions(['removeSectionBlock']),
  },
}
</script>
