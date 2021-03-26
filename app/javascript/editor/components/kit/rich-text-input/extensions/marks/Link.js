import { Link } from 'tiptap-extensions'

export default class MaglevLink extends Link {

  get name() {
    return 'link'
  }

  get schema() {
    return {
      attrs: {
        href: {
          default: null,
        },
        target: {
          default: null,
        },
        linkType: {
          default: null,
        },
        linkId: {
          default: null,
        }
      },
      inclusive: false,
      parseDOM: [
        {
          tag: 'a[href]',
          getAttrs: dom => ({
            href: dom.getAttribute('href'),
            target: dom.getAttribute('target'),
            linkType: dom.getAttribute('maglev-link-type'),
            linkId: dom.getAttribute('maglev-link-id'),            
          }),
        },
      ],
      toDOM: node => {
        const { linkType, linkId, ...attrs } = node.attrs;
        return ['a', {
          ...attrs,
          rel: 'noopener noreferrer nofollow',
          target: attrs.target || this.options.target,
          'maglev-link-type': linkType,
          'maglev-link-id': linkId,
        }, 0]
      }
    }
  }  
}