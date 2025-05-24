export const pageSections = [
  {
    id: 'GrYZW-VP',
    type: 'navbar_01',
    blocks: [
      {
        id: 'RiEo8C3f',
        type: 'navbar_item',
        settings: [
          {
            id: 'link',
            value: { href: '#', text: 'Home', linkType: 'url' },
          },
        ],
      },
      {
        id: 'P1fGieWs',
        type: 'navbar_item',
        settings: [
          {
            id: 'link',
            value: { href: '#', text: 'About us', linkType: 'url' },
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
              linkId: 9,
              linkType: 'page',
              linkLabel: 'Contact us',
              sectionId: null,
              openNewWindow: false,
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
              linkId: 'd870133f9a075477a96a58e7639d40c5',
              linkType: 'page',
              linkLabel: 'Products',
              sectionId: null,
              openNewWindow: true,
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
          byteSize: 35070,
        },
      },
    ],
  },
  {
    id: '8hKSujtd',
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
          byteSize: 41683,
        },
      },
      { id: 'button', value: { url: '#', text: 'Click here' } },
    ],
  },
  {
    id: 'xM6f-kyh',
    type: 'list_01',
    blocks: [
      {
        id: 'fNIEuzF0',
        type: 'list_item',
        settings: [
          { id: 'title', value: 'Item title' },
          {
            id: 'image',
            value: {
              id: 13,
              url: 'http://localhost:3000/maglev/assets/13',
              width: 1920,
              height: 1200,
              filename: 'img-97.jpg',
              byteSize: 458107,
            },
          },
        ],
      },
      {
        id: 'UVGOFAI5',
        type: 'list_item',
        settings: [
          { id: 'title', value: 'Item title' },
          {
            id: 'image',
            value: {
              id: 9,
              url: 'http://localhost:3000/maglev/assets/9',
              width: 516,
              height: 400,
              filename: 'inner-74-2.jpg',
              byteSize: 63881,
            },
          },
        ],
      },
      {
        id: 'K3Xotn7f',
        type: 'list_item',
        settings: [
          { id: 'title', value: 'Item title' },
          {
            id: 'image',
            value: {
              id: 12,
              url: 'http://localhost:3000/maglev/assets/12',
              width: 516,
              height: 320,
              filename: 'img-91-4.jpg',
              byteSize: 21808,
            },
          },
        ],
      },
      {
        id: 'Pst6WyU0',
        type: 'list_item',
        settings: [
          { id: 'title', value: 'Item title' },
          {
            id: 'image',
            value: {
              id: 11,
              url: 'http://localhost:3000/maglev/assets/11',
              width: 1920,
              height: 1200,
              filename: 'img-91.jpg',
              byteSize: 180178,
            },
          },
        ],
      },
    ],
    settings: [
      { id: 'title', value: 'Home [EN] v1.2.11' },
      {
        id: 'body',
        value:
          '\u003cp\u003eLorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque odio purus, suscipit nec arcu id, tempor feugiat risus. Maecenas cursus vehicula sagittis. Nulla \u003cstrong\u003e\u003cu\u003e\u003ca href="/" rel="noopener noreferrer nofollow" maglev-link-type="page" maglev-link-id="7"\u003evarius\u003c/a\u003e\u003c/u\u003e\u003c/strong\u003e sagittis nunc eget iaculis.\u003c/p\u003e',
      },
      { id: 'background_color', value: '#BFDBFE' },
    ],
  },
]

export const page = {
  sections: pageSections,
  id: 1,
  title: 'Home page',
  path: 'index',
  pathHash: { en: 'index', fr: 'index' },
  visible: true,
  seoTitle: 'My awesome home page',
  metaDescription: null,
  ogTitle: null,
  ogDescription: null,
  ogImageUrl: null,
  previewUrl: '/maglev/preview',
  liveUrl: '/',
  sectionNames: [
    { id: 'GrYZW-VP', name: 'Navbar 01' },
    { id: '8hKSujtd', name: 'Content #1' },
    { id: 'xM6f-kyh', name: 'List #1' },
  ],
  lockVersion: 1,
  translated: true,
}

export const normalizedPage = {
  entities: {
    blocks: {
      RiEo8C3f: {
        id: 'RiEo8C3f',
        type: 'navbar_item',
        settings: [
          { id: 'link', value: { href: '#', text: 'Home', linkType: 'url' } },
        ],
      },
      P1fGieWs: {
        id: 'P1fGieWs',
        type: 'navbar_item',
        settings: [
          {
            id: 'link',
            value: { href: '#', text: 'About us', linkType: 'url' },
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
              linkId: 9,
              linkType: 'page',
              linkLabel: 'Contact us',
              sectionId: null,
              openNewWindow: false,
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
              linkId: 'd870133f9a075477a96a58e7639d40c5',
              linkType: 'page',
              linkLabel: 'Products',
              sectionId: null,
              openNewWindow: true,
            },
          },
        ],
      },
      fNIEuzF0: {
        id: 'fNIEuzF0',
        type: 'list_item',
        settings: [
          { id: 'title', value: 'Item title' },
          {
            id: 'image',
            value: {
              id: 13,
              url: 'http://localhost:3000/maglev/assets/13',
              width: 1920,
              height: 1200,
              filename: 'img-97.jpg',
              byteSize: 458107,
            },
          },
        ],
      },
      UVGOFAI5: {
        id: 'UVGOFAI5',
        type: 'list_item',
        settings: [
          { id: 'title', value: 'Item title' },
          {
            id: 'image',
            value: {
              id: 9,
              url: 'http://localhost:3000/maglev/assets/9',
              width: 516,
              height: 400,
              filename: 'inner-74-2.jpg',
              byteSize: 63881,
            },
          },
        ],
      },
      K3Xotn7f: {
        id: 'K3Xotn7f',
        type: 'list_item',
        settings: [
          { id: 'title', value: 'Item title' },
          {
            id: 'image',
            value: {
              id: 12,
              url: 'http://localhost:3000/maglev/assets/12',
              width: 516,
              height: 320,
              filename: 'img-91-4.jpg',
              byteSize: 21808,
            },
          },
        ],
      },
      Pst6WyU0: {
        id: 'Pst6WyU0',
        type: 'list_item',
        settings: [
          { id: 'title', value: 'Item title' },
          {
            id: 'image',
            value: {
              id: 11,
              url: 'http://localhost:3000/maglev/assets/11',
              width: 1920,
              height: 1200,
              filename: 'img-91.jpg',
              byteSize: 180178,
            },
          },
        ],
      },
    },
    sections: {
      'GrYZW-VP': {
        id: 'GrYZW-VP',
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
              byteSize: 35070,
            },
          },
        ],
      },
      '8hKSujtd': {
        id: '8hKSujtd',
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
              byteSize: 41683,
            },
          },
          { id: 'button', value: { url: '#', text: 'Click here' } },
        ],
      },
      'xM6f-kyh': {
        id: 'xM6f-kyh',
        type: 'list_01',
        blocks: ['fNIEuzF0', 'UVGOFAI5', 'K3Xotn7f', 'Pst6WyU0'],
        settings: [
          { id: 'title', value: 'Home [EN] v1.2.11' },
          {
            id: 'body',
            value:
              '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque odio purus, suscipit nec arcu id, tempor feugiat risus. Maecenas cursus vehicula sagittis. Nulla <strong><u><a href="/" rel="noopener noreferrer nofollow" maglev-link-type="page" maglev-link-id="7">varius</a></u></strong> sagittis nunc eget iaculis.</p>',
          },
          { id: 'background_color', value: '#BFDBFE' },
        ],
      },
    },
    page: {
      1: {
        sections: ['GrYZW-VP', '8hKSujtd', 'xM6f-kyh'],
        id: 1,
        title: 'Home page',
        path: 'index',
        pathHash: { en: 'index', fr: 'index' },
        visible: true,
        seoTitle: 'My awesome home page',
        metaDescription: null,
        ogTitle: null,
        ogDescription: null,
        ogImageUrl: null,
        previewUrl: '/maglev/preview',
        liveUrl: '/',
        sectionNames: [
          { id: 'GrYZW-VP', name: 'Navbar 01' },
          { id: '8hKSujtd', name: 'Content #1' },
          { id: 'xM6f-kyh', name: 'List #1' },
        ],
        lockVersion: 1,
        translated: true,        
      },
    },
  },
  result: 1,
}
