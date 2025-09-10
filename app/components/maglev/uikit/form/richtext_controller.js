import { Controller } from '@hotwired/stimulus'
import { Editor } from "@tiptap/core"
import StarterKit from "@tiptap/starter-kit"
import Superscript from '@tiptap/extension-superscript'

export default class extends Controller {
  static targets = ['editor', 'hiddenInput', 'button']
  static values = { content: String }

  connect() {
    console.log('Richtext controller connected', this.boldButtonTarget)
    this.buildEditor()
  }

  buildEditor() {
    console.log('Building editor', this.editorTarget)
    this.editor = new Editor({
      element: this.editorTarget,
      extensions: [StarterKit, Superscript],
      content: this.contentValue,
      onSelectionUpdate: ({ editor }) => {
        // Simple actions
        this.toggleButtonState('bold', editor.isActive('bold'))        
        this.toggleButtonState('italic', editor.isActive('italic'))
        this.toggleButtonState('underline', editor.isActive('underline'))
        this.toggleButtonState('strikethrough', editor.isActive('strikethrough'))
        this.toggleButtonState('superscript', editor.isActive('superscript'))
      },
      onUpdate: ({ editor }) => {
        this.hiddenInputTarget.value = editor.getHTML()
        this.dispatch('onUpdate', { detail: { content: editor.getHTML() } })
      }
    })
  }

  disconnect() {
    this.editor?.destroy()
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

  toggleButtonState(actionName, isActive) {
    this.buttonTargets.forEach(button => {
      if (button.dataset.actionName !== actionName) return
      button.classList.toggle('active', isActive)
    })
  }
}