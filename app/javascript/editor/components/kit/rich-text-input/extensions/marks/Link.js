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
        },
        sectionId: {
          default: null,
        },
      },
      inclusive: false,
      parseDOM: [
        {
          tag: 'a[href]',
          getAttrs: (dom) => ({
            href: dom.getAttribute('href'),
            target: dom.getAttribute('target'),
            linkType: dom.getAttribute('maglev-link-type'),
            linkId: dom.getAttribute('maglev-link-id'),
            sectionId: dom.getAttribute('maglev-section-id'),
          }),
        },
      ],
      toDOM: (node) => {
        const { linkType, linkId, sectionId, ...attrs } = node.attrs
        return [
          'a',
          {
            ...attrs,
            rel: 'noopener noreferrer nofollow',
            target: attrs.target || this.options.target,
            'maglev-link-type': linkType,
            'maglev-link-id': linkId,
            'maglev-section-id': sectionId,
          },
          0,
        ]
      },
    }
  }
}
