<template>
  <div class="flex">
    <editor-menu-button
      iconName="format-link"
      class="rounded-l-sm"
      @click="openLinkPickerModal"
    />
    <editor-menu-button
      iconName="format-link-unlink"
      :isActive="isActive.link()"
      class="rounded-r-sm"
      @click="unLink"
    />
  </div>
</template>

<script>
import EditorMenuButton from './menu-button.vue'
import LinkPicker from '@/components/link-picker/index.vue'

export default {
  name: 'EditorLinkButtons',
  components: { EditorMenuButton },
  props: {
    editor: { type: Object, required: true },
    commands: { type: Object, required: true },
    isActive: { type: Object, required: true },
  },
  computed: {
    currentLink() {
      return this.isActive.link() ? { ...this.editor.getMarkAttrs('link') } : {}
    },
  },
  methods: {
    isSelectionEmpty() {
      const { view } = this.editor
      const { selection } = view.state
      return selection.empty && !this.isActive.link()
    },
    setLink(link) {
      var { linkType, linkId, sectionId, href, openNewWindow } = link
      this.commands.link({
        href,
        target: openNewWindow ? '_blank' : '',
        linkType,
        linkId,
        sectionId,
      })
      this.closeModal()
    },
    guessLinkType() {
      let type = this.currentLink?.linkType
      let href = this.currentLink?.href

      if (!type && href && href.startsWith('mailto:')) type = 'email'
      if (!type) type = 'url'

      return type
    },
    sanitizeLink() {
      let link = {
        linkType: this.guessLinkType(),
        linkId: this.currentLink.linkId,
        sectionId: this.currentLink.sectionId,
        href: this.currentLink.href,
        openNewWindow: this.currentLink.target === '_blank',
      }

      if (link.linkType === 'email') {
        const matching = /^mailto:(.*)$/g.exec(link.href)
        link.email = matching && matching[1] ? matching[1] : null
      }

      return link
    },
    openLinkPickerModal() {
      this.openModal({
        title: this.$t('linkPicker.insertTitle'),
        component: LinkPicker,
        props: { currentLink: this.sanitizeLink(), mode: 'insert', modalClass: 'h-144 w-120' },
        listeners: {
          select: (link) => this.setLink(link),
        },
      })
    },
    unLink() {
      this.commands.link({})
    },
  },
}
</script>
