<template>
  <div>
    <div
      class="block font-semibold text-gray-800"
      :for="name"
      @click="focus()"
    >
      {{ label }}
    </div>
    <div class="mt-1">
      <editor-menu-bar :editor="editor" v-slot="{ commands, isActive }">
        <div class="flex sticky top-0 z-10 pb-2 bg-white space-x-1 overflow-x-auto">
          <editor-block-button
            :commands="commands"
            :isActive="isActive"
            class="relative"
            v-if="!lineBreak"
          />

          <editor-format-buttons 
            :commands="commands" 
            :isActive="isActive"
            :extraExtensions="extraExtensions"
          />

          <editor-list-buttons
            :commands="commands"
            :isActive="isActive"
            v-if="!lineBreak"
          />

          <editor-link-buttons
            :editor="editor"
            :commands="commands"
            :isActive="isActive"
          />

          <editor-table-button
            :commands="commands"
            :isActive="isActive"
            class="relative"
            v-if="!lineBreak && extraExtensions.table"
          />
        </div>
      </editor-menu-bar>
      <div ref="editorWrapper" class="mt-1">
        <editor-content
          :editor="editor"
          class="rich-text-editor"
          :data-rows="rows"
        />
      </div>
    </div>
  </div>
</template>

<script>
import FocusedInputMixin from '@/mixins/focused-input'
import { Editor, EditorContent, EditorMenuBar, Text, Paragraph } from 'tiptap'
import {
  Blockquote,
  CodeBlock,
  HardBreak,
  Heading,
  OrderedList,
  BulletList,
  ListItem,
  Bold,
  Italic,
  Strike,
  Underline,
  History,
  Table,
  TableHeader,
  TableCell,
  TableRow
} from 'tiptap-extensions'
import Doc from './rich-text-input/extensions/Doc'
import LineBreak from './rich-text-input/extensions/LineBreak'
import Link from './rich-text-input/extensions/marks/Link'
import Superscript from './rich-text-input/extensions/marks/Superscript'
import EditorBlockButton from './rich-text-input/block-button.vue'
import EditorFormatButtons from './rich-text-input/format-buttons.vue'
import EditorListButtons from './rich-text-input/list-buttons.vue'
import EditorLinkButtons from './rich-text-input/link-buttons.vue'
import EditorTableButton from './rich-text-input/table-button.vue'

export default {
  name: 'UIKitRichTextInput',
  mixins: [FocusedInputMixin],
  components: {
    EditorContent,
    EditorMenuBar,
    EditorBlockButton,
    EditorFormatButtons,
    EditorListButtons,
    EditorLinkButtons,
    EditorTableButton,
  },
  props: {
    label: { type: String, default: 'Label' },
    name: { type: String, default: 'text' },
    value: { type: String },
    lineBreak: { type: Boolean, default: false },
    rows: { type: Number, default: 2 },
    extraExtensions: { type: Object, default: () => ({ table: false, superscript: false }) },
  },
  data() {
    return { editor: null }
  },
  mounted() {
    this.editor = new Editor({
      extensions: this.buildExtensions(),
      useBuiltInExtensions: !this.lineBreak,
      content: this.value,
      onUpdate: ({ getHTML }) => {
        let content = getHTML()
        content = this.lineBreak
          ? this.getHTMLWithinParagraph(content)
          : content
        this.$emit('input', content)
      },
      onBlur: () => this.blur(),
    })
  },
  beforeDestroy() {
    // insert a empty div in place of the editor content component
    // to avoid the flickering when closing the slide-pane
    let rect = this.editor.view.dom.getBoundingClientRect()
    let div = document.createElement('div')
    div.classList.add('py-2', 'px-3', 'rounded', 'bg-gray-100') // .ProseMirror
    div.style.height = `${rect.height}px`
    div.style.width = '100%'
    this.$refs.editorWrapper.appendChild(div)

    // clean stuff
    this.editor.destroy()
  },
  methods: {
    focus() {
      this.editor.focus('end')
      // NOTE: if lineBreak is true, focus('end') will throw an exception
      // when pressing the ENTER key.
      if (this.lineBreak) {
        const { from, to } = this.editor.resolveSelection('end')
        this.editor.setSelection(from - 1, to - 1)
      }
    },
    getHTMLWithinParagraph(content) {
      return content.replace(/<\/?p>/g, '')
    },
    buildDefaultExtensions() {
      return [
        new Bold(),
        new Italic(),
        new Underline(),
        new Strike(),
        new Link({ openOnClick: false, target: null }),
        new Superscript(),
        new History(),
      ]
    },
    buildExtensions() {
      if (this.lineBreak) {
        return [].concat(
          [new Doc(), new Text(), new Paragraph(), new LineBreak()],
          this.buildDefaultExtensions(),
        )
      } else {
        return [].concat(this.buildDefaultExtensions(), [
          new HardBreak(),
          new Heading({ levels: [2, 3] }),
          new Blockquote(),
          new CodeBlock(),
          new BulletList(),
          new ListItem(),
          new OrderedList(),
          new Table({ resizable: true }),
          new TableHeader(),
          new TableCell(),
          new TableRow(),
        ])
      }
    },
  },
}
</script>
