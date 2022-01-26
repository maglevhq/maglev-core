<template>
  <div>
    <div v-if="isListEmpty" class="text-center mt-8">
      <span class="text-gray-800">{{ $t('sections.listPane.empty') }}</span>
    </div>
    <draggable :list="list" @end="onSortEnd" v-bind="dragOptions" v-else>
      <transition-group type="transition" name="flip-list">
        <list-item
          v-for="(section, index) in list"
          :key="section.id"
          :section="section"
          :index="index"
          @on-dropdown-toggle="onDropdownToggle"
          class="mb-3"
        />
      </transition-group>
    </draggable>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import draggable from 'vuedraggable'
import GroupedDropdownsMixin from '@/mixins/grouped-dropdowns'
import ListItem from './list-item'

export default {
  name: 'SectionList',
  mixins: [GroupedDropdownsMixin],
  components: { draggable, ListItem },
  computed: {
    list() {
      return this.currentSectionList
    },
    isListEmpty() {
      return this.currentSectionList.length === 0
    },
    dragOptions() {
      return {
        animation: 0,
        group: 'description',
        disabled: false,
        ghostClass: 'ghost',
      }
    },
  },
  methods: {
    ...mapActions(['moveSection']),
    onSortEnd(event) {
      this.moveSection({
        from: event.oldIndex,
        to: event.newIndex,
      })
    },
  },
}
</script>

<style scope>
.flip-list-move {
  @apply transition-transform;
  @apply duration-300;
}
</style>
