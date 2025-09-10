import { Controller } from '@hotwired/stimulus'
import { Editor } from "@tiptap/core"
import Document from '@tiptap/extension-document'
import Text from '@tiptap/extension-text'
import Paragraph from '@tiptap/extension-paragraph'
import Heading from '@tiptap/extension-heading'
import Blockquote from '@tiptap/extension-blockquote'
import CodeBlock from '@tiptap/extension-code-block'
import History from '@tiptap/extension-history'
import Bold from '@tiptap/extension-bold'
import Italic from '@tiptap/extension-italic'
import Underline from '@tiptap/extension-underline'
import Strike from '@tiptap/extension-strike'
import Superscript from '@tiptap/extension-superscript'
import HardBreak from '@tiptap/extension-hard-break'

export default class extends Controller {
  static targets = ['editor', 'hiddenInput', 'button', 'blockButton']
  static values = { content: String, lineBreak: Boolean }

  connect() {
    this.buildEditor()
  }

  buildEditor() {
    this.editor = new Editor({
      element: this.editorTarget,
      extensions: this.buildExtensions(),
      content: this.contentValue,
      onSelectionUpdate: ({ editor }) => {
        // Simple actions
        this.toggleButtonState('bold', editor.isActive('bold'))        
        this.toggleButtonState('italic', editor.isActive('italic'))
        this.toggleButtonState('underline', editor.isActive('underline'))
        this.toggleButtonState('strikethrough', editor.isActive('strikethrough'))
        this.toggleButtonState('superscript', editor.isActive('superscript'))
        this.toggleButtonState('unordered_list', editor.isActive('bulletList'))
        this.toggleButtonState('ordered_list', editor.isActive('orderedList'))

        // Block buttons
        this.toggleBlockButtonState()
      },
      onUpdate: ({ editor }) => {
        const content = this.getHTML(editor)
        this.hiddenInputTarget.value = content
        this.dispatch('onUpdate', { detail: { content } })
      }
    })
    this.toggleBlockButtonState()
  }

  disconnect() {
    this.editor?.destroy()
  }

  buildExtensions() {
    const extensions = [
      Document, Text, History, Bold, Italic, Underline, Strike, Superscript,
      Paragraph, Blockquote, CodeBlock,
      Heading.configure({
        levels: [2, 3, 4],
      })
    ]
    if (this.lineBreakValue) {
      const customHardBreak = HardBreak.extend({
        addKeyboardShortcuts () {
          return {
            Enter: () => this.editor.commands.setHardBreak()
          }
        }
      })
      extensions.push(customHardBreak)
    }
    return extensions
  }

  getHTML(editor) {
    const content = editor.getHTML()
    return this.lineBreakValue ? content.replace(/<\/?p>/g, '') : content      
  }

  focus() {
    this.editor.commands.focus('end')
  }

  bold(event) {
    this.editor.chain().focus().toggleBold().run()
    event.currentTarget.classList.toggle('active')
  }

  italic(event) {
    this.editor.chain().focus().toggleItalic().run()
    event.currentTarget.classList.toggle('active')
  }

  underline(event) {
    this.editor.chain().focus().toggleUnderline().run()
    event.currentTarget.classList.toggle('active')
  }

  strikethrough(event) {
    this.editor.chain().focus().toggleStrike().run()
    event.currentTarget.classList.toggle('active')
  }

  superscript(event) {
    this.editor.chain().focus().toggleSuperscript().run()
    event.currentTarget.classList.toggle('active')
  }

  unorderedList(event) {
    this.editor.chain().focus().toggleBulletList().run()
    event.currentTarget.classList.toggle('active')
  }

  orderedList(event) {
    this.editor.chain().focus().toggleOrderedList().run()
    event.currentTarget.classList.toggle('active')
  }

  toggleParagraph() {
    this.editor.commands.setParagraph()
    this.toggleBlockButtonState()
  }

  toggleHeading2() {
    this.editor.commands.toggleHeading({ level: 2 })
    this.toggleBlockButtonState()
  }

  toggleHeading3() {
    this.editor.commands.toggleHeading({ level: 3 })
    this.toggleBlockButtonState()
  }

  toggleHeading4() {
    this.editor.commands.toggleHeading({ level: 4 })
    this.toggleBlockButtonState()
  }

  toggleBlockquote() {
    this.editor.commands.toggleBlockquote()
    this.toggleBlockButtonState()
  }

  toggleCodeBlock() {
    this.editor.commands.toggleCodeBlock()
    this.toggleBlockButtonState()
  }

  toggleButtonState(actionName, isActive) {
    this.buttonTargets.forEach(button => {
      if (button.dataset.actionName !== actionName) return
      button.classList.toggle('active', isActive)
    })
  }

  toggleBlockButtonState() {
    let name = null
    if (this.editor.isActive('paragraph')) {
      name = 'paragraph'
    } else if (this.editor.isActive('heading', { level: 2 })) {
      name = 'heading_2'
    } else if (this.editor.isActive('heading', { level: 3 })) {
      name = 'heading_3'
    } else if (this.editor.isActive('heading', { level: 4 })) {
      name = 'heading_4'
    } else if (this.editor.isActive('blockquote')) {
      name = 'blockquote'
    } else if (this.editor.isActive('codeBlock')) {
      name = 'code_block'
    }
    this.blockButtonTarget.querySelectorAll(`[data-block-button-name]`).forEach(button => {
      button.classList.toggle('hidden', button.dataset.blockButtonName !== name)
    })
  } 
}