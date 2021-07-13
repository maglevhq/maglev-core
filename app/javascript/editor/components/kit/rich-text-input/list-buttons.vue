<template>
  <div class="flex">
    <editor-menu-button
      iconName="format-list-unordered"
      class="rounded-l-sm"
      :isActive="isActive.bullet_list()"
      @click="commands.bullet_list"
    />
    <editor-menu-button
      iconName="format-list-ordered"
      class="rounded-r-sm"
      :isActive="isActive.ordered_list()"
      @click="commands.ordered_list"
    />
  </div>
</template>

<script>
import EditorMenuButton from './menu-button.vue'

export default {
  name: 'EditorListButtons',
  components: { EditorMenuButton },
  props: {
    commands: { type: Object, required: true },
    isActive: { type: Object, required: true },
  },
}
</script>
