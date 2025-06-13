<template>
  <div class="space-y-2">
    <div class="flex items-center justify-between min-h-8">
      <h3 class=" text-gray-800 font-semibold sticky top-0 bg-white">
        {{ layoutGroup.label }}
      </h3>
      <router-link
        :to="{ name: 'addSection', params: { layoutGroupId } }"
        class="flex items-center justify-center w-8 h-8 rounded-md hover:bg-gray-100"
        v-if="displayQuickAddButton">
        <uikit-icon name="ri-add-line" size="1.4rem" />
      </router-link>
    </div>
    <div v-if="isListEmpty" class="text-center text-sm space-y-1">
      <p class="text-gray-600 text-sm">{{ $t('sections.listPane.empty.title') }}</p>
      <p class="flex justify-center" v-if="canAdd">
        <router-link
          :to="{ name: 'addSection', params: { layoutGroupId } }"
          class="flex items-center space-x-1 text-gray-800 hover:bg-gray-100 px-3 py-2 rounded-sm">
          <uikit-icon name="add-box-line" size="1rem" />
          <span class="text-sm">{{ $t('sections.listPane.empty.button') }}</span>
        </router-link>
      </p>
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
        handle: '.cursor-move',
      }
    },
    canAdd()  {
      return this.canAddSection(this.layoutGroupId)
      // return false
    },
    displayQuickAddButton() {
      return this.canAdd && !this.isListEmpty
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
    }
  },
}
</script>

<style scope>
.flip-list-move {
  @apply transition-transform;
  @apply duration-300;
}
</style>
