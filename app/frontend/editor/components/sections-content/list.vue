<template>
  <div class="space-y-4">
    <h3 class="uppercase text-gray-800 antialiased text-xs font-semibold sticky top-0 bg-white pt-2">
      {{ layoutGroup.label }}
    </h3>
    <div v-if="isListEmpty" class="text-center">
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

    <p class="flex justify-center" v-if="canAdd">
      <router-link
        :to="{ name: 'addSection', params: { layoutGroupId } }"
        class="flex items-center space-x-1 transition-colors duration-200 text-gray-500 hover:text-editor-primary">
        <uikit-icon name="add-box-line" size="1rem" />
        <span>Add section</span>
      </router-link>
    </p>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'
import draggable from 'vuedraggable'
import GroupedDropdownsMixin from '@/mixins/grouped-dropdowns'
import ListItem from './list-item.vue'

export default {
  name: 'SectionList',
  mixins: [GroupedDropdownsMixin],
  components: { draggable, ListItem },
  props: {
    layoutGroup: { type: Object, required: true },
  },
  computed: {
    ...mapGetters(['canAddSection']),
    list() {
      return this.layoutGroup.sections
    },
    isListEmpty() {
      return this.list.length === 0
    },
    layoutGroupId() {
      return this.layoutGroup.id
    },
    dragOptions() {
      return {
        animation: 0,
        group: `sections-${this.layoutGroupId}`,
        disabled: false,
        ghostClass: 'ghost',
      }
    },
    canAdd()  {
      return this.canAddSection(this.layoutGroupId)
      // return false
    }
  },
  methods: {
    ...mapActions(['moveSection']),
    onSortEnd(event) {
      this.moveSection({
        layoutGroupId:this.layoutGroupId,
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
