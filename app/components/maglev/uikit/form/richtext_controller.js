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
import Link from '@tiptap/extension-link'
import { ListItem,BulletList, OrderedList } from '@tiptap/extension-list'

const MaglevLink = Link.extend({
  addAttributes() {
    return {
      href: {
        default: null,
        parseHTML(element) {
          return element.getAttribute('href')
        },
      },
      target: {
        default: this.options.HTMLAttributes.target,
      },
      rel: {
        default: this.options.HTMLAttributes.rel,
      },
      class: {
        default: this.options.HTMLAttributes.class,
      },
      'maglev-link-type': {
        default: 'url'
      },
      'maglev-link-id': {
        default: null,
      },
      'maglev-section-id': {
        default: null,
      },
    }
  },
})

export default class extends Controller {
  static targets = ['editor', 'hiddenInput', 'button', 'blockButton']
  static values = { inputName: String, content: String, lineBreak: Boolean, editLinkPath: String }

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
        this.toggleButtonState('link', editor.isActive('link'))

        // Block buttons
        this.toggleBlockButtonState()
      },
      onUpdate: ({ editor }) => {
        const content = this.getHTML(editor)
        this.hiddenInputTarget.value = content
        this.dispatch('change', { detail: { value:content } })
      }
    })
    this.toggleBlockButtonState()
  }

  disconnect() {
    this.editor?.destroy()
    this.editor = null
  }

  buildExtensions() {
    const extensions = [
      Document, Text, Paragraph, History, Bold, Italic, Underline, Strike, Superscript,
      MaglevLink.configure({ openOnClick: false, target: null }),
    ]
    // Line break (ie: <br> instead of <p>)
    if (this.lineBreakValue) {
      const customHardBreak = HardBreak.extend({
        addKeyboardShortcuts () {
          return {
            Enter: () => this.editor.commands.setHardBreak()
          }
        }
      })
      extensions.push(customHardBreak)
    } else {
      extensions.push(
        Blockquote, CodeBlock, ListItem, BulletList, OrderedList,
        Heading.configure({ levels: [2, 3, 4] })
      )
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

  // Mark buttons

  toggleBold(event) {
    this.editor.chain().focus().toggleBold().run()
    event.currentTarget.classList.toggle('active')
  }

  toggleItalic(event) {
    this.editor.chain().focus().toggleItalic().run()
    event.currentTarget.classList.toggle('active')
  }

  toggleUnderline(event) {
    this.editor.chain().focus().toggleUnderline().run()
    event.currentTarget.classList.toggle('active')
  }

  toggleStrikethrough(event) {
    this.editor.chain().focus().toggleStrike().run()
    event.currentTarget.classList.toggle('active')
  }

  toggleSuperscript(event) {
    this.editor.chain().focus().toggleSuperscript().run()
    event.currentTarget.classList.toggle('active')
  }

  toggleUnorderedList(event) {
    this.editor.commands.toggleBulletList()
    event.currentTarget.classList.toggle('active', this.editor.isActive('bulletList'))
    this.toggleButtonState('ordered_list', false)
  }

  toggleOrderedList(event) {
    this.editor.chain().focus().toggleOrderedList().run()
    event.currentTarget.classList.toggle('active', this.editor.isActive('orderedList'))
    this.toggleButtonState('unordered_list', false)
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

  toggleButtonState(name, isActive) {
    this.buttonTargets.forEach(button => {
      if (button.dataset.name !== name) return
      button.classList.toggle('active', isActive)
    })
  }

  toggleBlockButtonState() {
    if (!this.hasBlockButtonTarget) return

    let name = 'paragraph'
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

  openLinkModal(event) {
    console.log('toggleLink', event)
    const url = new URL(this.editLinkPathValue, window.location.origin)
    const link = this.editor.getAttributes('link')

    console.log('toggleLink,build link from', link)
    
    url.searchParams.set('input_name', this.inputNameValue)
    url.searchParams.set('link[href]', link.href ?? '')
    url.searchParams.set('link[link_id]', link['maglev-link-id'])
    url.searchParams.set('link[section_id]', link['maglev-section-id'])
    url.searchParams.set('link[open_new_window]', link.target === '_blank')

    // get or guess the link type
    let linkType = link['maglev-link-type']
    if (!linkType) linkType = link.href?.startsWith('mailto:') ? 'email' : 'url'
    url.searchParams.set('link[link_type]', linkType)
    
    // email
    if (linkType === 'email')
      url.searchParams.set('link[email]', link.href.replace('mailto:', ''))
    
    Turbo.visit(url, { frame: 'modal' })
  }

  setLink(event) {
    const link = JSON.parse(event.detail)
    console.log('setLink, link=', link)
    this.editor.commands.setLink({ 
      href: link.href, 
      target: link.open_new_window ? '_blank' : '', 
      'maglev-link-type': link.link_type,
      'maglev-link-id': link.link_id,
      'maglev-section-id': link.section_id
    })
  }

  unsetLink() {
    this.editor.commands.unsetLink()
    this.toggleButtonState('link', false)
  }
}