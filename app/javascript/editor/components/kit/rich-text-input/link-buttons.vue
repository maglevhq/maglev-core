<template>
  <div class="flex">    
    <editor-menu-button
      iconName="format-link" 
      class="rounded-l-sm"
      @click="openLinkPicker" 
    /> 
    <editor-menu-button
      iconName="format-link-unlink" 
      :isActive="isActive.link()"
      class="rounded-r-sm"
      @click="unLink" 
    /> 

    <link-picker 
      :show="showLinkPicker"
      :currentLink="currentLink"
      @set="setLink"
      @close="closeLinkPicker" 
    />
  </div>
</template>

<script>
import EditorMenuButton from './menu-button.vue'
import LinkPicker from '@/components/link-picker'

export default {
  name: 'EditorLinkButtons',
  components: { EditorMenuButton, LinkPicker },
  props: {
    editor: { type: Object, required: true },
    commands: { type: Object, required: true },    
    isActive: { type: Object, required: true },
  },
  data() {
    return { showLinkPicker: false }
  },
  computed: {
    currentLink() {
      return this.isActive.link() ? { ...this.editor.getMarkAttrs('link') } : {};
    },
  },
  methods: {
    isSelectionEmpty() {
      const { view } = this.editor;
      const { selection } = view.state;
      return selection.empty && !this.isActive.link();
    },
    setLink(link) {
      var { linkType, linkId, href, openNewWindow } = link
      this.commands.link({ 
        href, 
        target: openNewWindow ? '_blank' : '',
        linkType,
        linkId,
      })
      this.closeLinkPicker()
    },
    openLinkPicker() { 
      this.showLinkPicker = !this.isSelectionEmpty()
    },
    closeLinkPicker() {
      this.showLinkPicker = false
    },
    unLink() {
      this.commands.link({})
    }
  }
}
</script>
