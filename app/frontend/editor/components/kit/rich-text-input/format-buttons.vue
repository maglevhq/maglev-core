<template>
  <div class="flex">
    <editor-menu-button
      iconName="format-bold"
      class="rounded-l-sm"
      :isActive="isActive.bold()"
      @click="commands.bold"
    />
    <editor-menu-button
      iconName="format-italic"
      :isActive="isActive.italic()"
      @click="commands.italic"
    />
    <editor-menu-button
      iconName="format-underline"
      :isActive="isActive.underline()"
      @click="commands.underline"
    />
    <editor-menu-button
      iconName="format-strikethrough"
      class="rounded-r-sm"
      :isActive="isActive.strike()"
      @click="commands.strike"
    />
    <editor-menu-button
      iconName="format-superscript"
      class="rounded-r-sm"
      :isActive="isActive.sup()"
      @click="commands.sup"
      v-if="extraExtensions.superscript"
    />
  </div>
</template>

<script>
import EditorMenuButton from './menu-button.vue'

export default {
  name: 'EditorFormatButtons',
  components: { EditorMenuButton },
  props: {
    commands: { type: Object, required: true },
    isActive: { type: Object, required: true },
    extraExtensions: { type: Object, default: () => ({ table: false, superscript: false }) },
  }
}
</script>
