export const simpleContentSection = {
  id: 'NEW-CONTENT-1',
  type: 'content_01',
  blocks: [],
  settings: [
    { id: 'pre_title', value: 'preTitle' },
    { id: 'title', value: 'My awesome title!' },
    {
      id: 'body',
      value:
        '\u003cp\u003eLorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque odio purus, suscipit nec arcu id, tempor feugiat risus. Maecenas cursus vehicula sagittis. Nulla varius sagittis nunc eget iaculis.\u003c/p\u003e',
    },
    {
      id: 'image',
      value: {
        id: 14,
        url: 'http://localhost:3000/maglev/assets/14',
        width: 516,
        height: 320,
        filename: 'img-91-3.jpg',
        byte_size: 41683,
      },
    },
    { id: 'button', value: { url: '#', text: 'Click here' } },
  ],
}

export const normalizedSimpleContentSection = {
  entities: {
    sections: {
      'NEW-CONTENT-1': {
        id: 'NEW-CONTENT-1',
        type: 'content_01',
        blocks: [],
        settings: [
          { id: 'pre_title', value: 'preTitle' },
          { id: 'title', value: 'My awesome title!' },
          {
            id: 'body',
            value:
              '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque odio purus, suscipit nec arcu id, tempor feugiat risus. Maecenas cursus vehicula sagittis. Nulla varius sagittis nunc eget iaculis.</p>',
          },
          {
            id: 'image',
            value: {
              id: 14,
              url: 'http://localhost:3000/maglev/assets/14',
              width: 516,
              height: 320,
              filename: 'img-91-3.jpg',
              byte_size: 41683,
            },
          },
          { id: 'button', value: { url: '#', text: 'Click here' } },
        ],
      },
    },
  },
  result: 'NEW-CONTENT-1',
}

export const navContentSection = {
  id: 'NEW-NAV-CONTENT-1',
  type: 'navbar_01',
  blocks: [
    {
      id: 'RiEo8C3f',
      type: 'navbar_item',
      settings: [
        {
          id: 'link',
          value: { href: '#', text: 'Home', link_type: 'url' },
        },
      ],
    },
    {
      id: 'P1fGieWs',
      type: 'navbar_item',
      settings: [
        {
          id: 'link',
          value: { href: '#', text: 'About us', link_type: 'url' },
        },
      ],
    },
    {
      id: 'sDo-Dg85',
      type: 'navbar_item',
      settings: [
        {
          id: 'link',
          value: {
            href: '//contact',
            text: 'Contact',
            email: null,
            link_id: 9,
            link_type: 'page',
            link_label: 'Contact us',
            section_id: null,
            open_new_window: false,
          },
        },
      ],
    },
    {
      id: 'K-C_zRcH',
      type: 'navbar_item',
      settings: [
        {
          id: 'link',
          value: {
            href: '/products',
            text: 'Products #1',
            email: null,
            link_id: 'd870133f9a075477a96a58e7639d40c5',
            link_type: 'page',
            link_label: 'Products',
            section_id: null,
            open_new_window: true,
          },
        },
      ],
    },
  ],
  settings: [
    {
      id: 'logo',
      value: {
        id: 15,
        url: 'http://localhost:3000/maglev/assets/15',
        width: 572,
        height: 290,
        filename: 'Screen Shot 2021-06-30 at 3.44.04 PM.png',
        byte_size: 35070,
      },
    },
  ],
}

export const normalizedNavContentSection = {
  entities: {
    blocks: {
      RiEo8C3f: {
        id: 'RiEo8C3f',
        type: 'navbar_item',
        settings: [
          { id: 'link', value: { href: '#', text: 'Home', link_type: 'url' } },
        ],
      },
      P1fGieWs: {
        id: 'P1fGieWs',
        type: 'navbar_item',
        settings: [
          {
            id: 'link',
            value: { href: '#', text: 'About us', link_type: 'url' },
          },
        ],
      },
      'sDo-Dg85': {
        id: 'sDo-Dg85',
        type: 'navbar_item',
        settings: [
          {
            id: 'link',
            value: {
              href: '//contact',
              text: 'Contact',
              email: null,
              link_id: 9,
              link_type: 'page',
              link_label: 'Contact us',
              section_id: null,
              open_new_window: false,
            },
          },
        ],
      },
      'K-C_zRcH': {
        id: 'K-C_zRcH',
        type: 'navbar_item',
        settings: [
          {
            id: 'link',
            value: {
              href: '/products',
              text: 'Products #1',
              email: null,
              link_id: 'd870133f9a075477a96a58e7639d40c5',
              link_type: 'page',
              link_label: 'Products',
              section_id: null,
              open_new_window: true,
            },
          },
        ],
      },
    },
    sections: {
      'NEW-NAV-CONTENT-1': {
        id: 'NEW-NAV-CONTENT-1',
        type: 'navbar_01',
        blocks: ['RiEo8C3f', 'P1fGieWs', 'sDo-Dg85', 'K-C_zRcH'],
        settings: [
          {
            id: 'logo',
            value: {
              id: 15,
              url: 'http://localhost:3000/maglev/assets/15',
              width: 572,
              height: 290,
              filename: 'Screen Shot 2021-06-30 at 3.44.04 PM.png',
              byte_size: 35070,
            },
          },
        ],
      },
    },
  },
  result: 'NEW-NAV-CONTENT-1',
}

export const navContentSectionBlock = {
  id: 'NEW-BLOCK-CONTENT-1',
  type: 'navbar_item',
  settings: [
    {
      id: 'link',
      value: { href: '#', text: 'Foo', link_type: 'url' },
    },
  ],
}
