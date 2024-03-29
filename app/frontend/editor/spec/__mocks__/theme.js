export const theme = {
  id: 'theme',
  name: 'Default theme',
  description: 'The default Maglev theme',
  sections: [
    {
      id: 'content_01',
      name: 'Content #1',
      category: 'contents',
      siteScoped: false,
      singleton: false,
      viewportFixedPosition: false,
      insertButton: true,
      insertAt: null,
      blocksLabel: null,
      blocksPresentation: null,
      sample: null,
      settings: [
        {
          id: 'pre_title',
          label: 'Pre-Title',
          type: 'text',
          default: 'preTitle',
          options: {},
        },
        {
          id: 'title',
          label: 'Title',
          type: 'text',
          default: 'My awesome title!!',
          options: {},
        },
        {
          id: 'body',
          label: 'Body',
          type: 'text',
          default:
            '\u003cp\u003eLorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque odio purus, suscipit nec arcu id, tempor feugiat risus. Maecenas cursus vehicula sagittis. Nulla varius sagittis nunc eget iaculis.\u003c/p\u003e',
          options: { html: true, nbRows: 6, htmlTable: false },
        },
        {
          id: 'image',
          label: 'Image',
          type: 'image',
          default: '/maglev-placeholder.jpg',
          options: {},
        },
        {
          id: 'button',
          label: 'Button',
          type: 'link',
          default: { url: '#', text: 'Click here!' },
          options: { withText: true, html: true },
        },
      ],
      blocks: [],
      themeId: 'theme',
      screenshotPath: '/theme/content_01.jpg?1629072715',
    },
    {
      id: 'navbar_01',
      name: 'Navbar 01',
      category: 'navbars',
      siteScoped: true,
      singleton: false,
      viewportFixedPosition: false,
      insertButton: false,
      insertAt: 'top',
      blocksLabel: 'Menu items',
      blocksPresentation: 'tree',
      sample: {
        settings: { logo: '/theme/image-placeholder.jpg' },
        blocks: [
          {
            type: 'navbar_item',
            settings: { link: { text: 'Home', linkType: 'url', href: '#' } },
          },
          {
            type: 'navbar_item',
            settings: {
              link: { text: 'About us', linkType: 'url', href: '#' },
            },
            children: [
              {
                type: 'navbar_item',
                settings: {
                  link: { text: 'The company', linkType: 'url', href: '#' },
                },
              },
              {
                type: 'navbar_item',
                settings: {
                  link: { text: 'Our team', linkType: 'url', href: '#' },
                },
              },
            ],
          },
        ],
      },
      settings: [
        {
          id: 'logo',
          label: 'Logo',
          type: 'image',
          default: '/theme/image-placeholder.jpg',
          options: {},
        },
      ],
      blocks: [
        {
          name: 'Navbar item',
          type: 'navbar_item',
          root: true,
          settings: [
            {
              id: 'link',
              label: 'Link',
              type: 'link',
              default: { text: 'New link', linkType: 'url', href: '#' },
              options: { withText: true },
            },
          ],
        },
      ],
      themeId: 'theme',
      screenshotPath: '/theme/navbar_01.jpg?1630443957',
    },
    {
      id: 'showcase',
      name: 'showcase',
      category: 'contents',
      siteScoped: false,
      singleton: false,
      viewportFixedPosition: false,
      insertButton: true,
      insertAt: null,
      blocksLabel: null,
      blocksPresentation: null,
      sample: {
        settings: {
          title:
            "Let's create the product\u003cbr/\u003eyour clients\u003cbr/\u003ewill love.",
          image: '/maglev-placeholder.jpg',
        },
        blocks: [
          {
            type: 'list_item',
            settings: { title: 'Item #1', image: '/maglev-placeholder.jpg' },
          },
          {
            type: 'list_item',
            settings: { title: 'Item #2', image: '/maglev-placeholder.jpg' },
          },
          {
            type: 'list_item',
            settings: { title: 'Item #3', image: '/maglev-placeholder.jpg' },
          },
          {
            type: 'list_item',
            settings: { title: 'Item #4', image: '/maglev-placeholder.jpg' },
          },
        ],
      },
      settings: [
        {
          id: 'title',
          label: 'My awesome title',
          type: 'text',
          default: 'My awesome title',
          options: {},
        },
        {
          id: 'image',
          label: 'An image',
          type: 'image',
          default: '/maglev-placeholder.jpg',
          options: {},
        },
      ],
      blocks: [
        {
          name: 'List item',
          type: 'list_item',
          root: true,
          settings: [
            {
              id: 'title',
              label: 'Item title',
              type: 'text',
              default: 'Item title',
              options: {},
            },
            {
              id: 'image',
              label: 'Item image',
              type: 'image',
              default: '/maglev-placeholder.jpg',
              options: {},
            },
          ],
        },
      ],
      themeId: 'theme',
      screenshotPath: '/theme/showcase.jpg?',
    },
    {
      id: 'list_01',
      name: 'List #1',
      category: 'lists',
      siteScoped: false,
      singleton: false,
      viewportFixedPosition: false,
      insertButton: true,
      insertAt: null,
      blocksLabel: null,
      blocksPresentation: null,
      sample: null,
      settings: [
        {
          id: 'title',
          label: 'Title',
          type: 'text',
          default: 'My awesome title',
          options: {},
        },
        {
          id: 'body',
          label: 'Body',
          type: 'text',
          default:
            '\u003cp\u003eLorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque odio purus, suscipit nec arcu id, tempor feugiat risus. Maecenas cursus vehicula sagittis. Nulla varius sagittis nunc eget iaculis.\u003c/p\u003e',
          options: { html: true, nbRows: 20 },
        },
        {
          id: 'background_color',
          label: 'Background color',
          type: 'color',
          options: {
            presets: ['#FECACA', '#FDE68A', '#A7F3D0', '#BFDBFE'],
            advanced: true,
          },
        },
      ],
      blocks: [
        {
          name: 'List item',
          type: 'list_item',
          root: true,
          settings: [
            {
              id: 'title',
              label: 'Title',
              type: 'text',
              default: 'Item title',
              options: {},
            },
            {
              id: 'image',
              label: 'Item image',
              type: 'image',
              default: '/maglev-placeholder.jpg',
              options: {},
            },
          ],
        },
      ],
      themeId: 'theme',
      screenshotPath: '/theme/list_01.jpg?',
    },
    {
      id: 'list_02',
      name: 'list_02',
      category: 'lists',
      siteScoped: false,
      singleton: false,
      viewportFixedPosition: false,
      insertButton: true,
      insertAt: null,
      blocksLabel: null,
      blocksPresentation: 'tree',
      sample: null,
      settings: [
        {
          id: 'title',
          label: 'My awesome title',
          type: 'text',
          default: 'My awesome title',
          options: {},
        },
        {
          id: 'image',
          label: 'An image',
          type: 'image',
          default: '/maglev-placeholder.png',
          options: {},
        },
      ],
      blocks: [
        {
          name: 'List item',
          type: 'list_item',
          root: true,
          settings: [
            {
              id: 'title',
              label: 'Item title',
              type: 'text',
              default: 'Item title',
              options: {},
            },
            {
              id: 'image',
              label: 'Item image',
              type: 'image',
              default: '/maglev-placeholder.png',
              options: {},
            },
          ],
        },
      ],
      themeId: 'theme',
      screenshotPath: '/theme/list_02.jpg?',
    },
    {
      id: 'footer_01',
      name: 'Footer #1',
      category: 'footers',
      siteScoped: true,
      singleton: true,
      viewportFixedPosition: false,
      insertButton: false,
      insertAt: 'bottom',
      blocksLabel: null,
      blocksPresentation: null,
      sample: null,
      settings: [
        {
          id: 'title',
          label: 'Title',
          type: 'text',
          default: 'Title',
          options: {},
        },
        {
          id: 'foo',
          label: 'Icon',
          type: 'icon',
          default: 'icon-af-counter',
          options: {},
        },
      ],
      blocks: [],
      themeId: 'theme',
      screenshotPath: '/theme/footer_01.jpg?1638542791',
    },
    {
      id: 'highlighted_product_01',
      name: 'Highlighted Product #1',
      category: 'contents',
      siteScoped: false,
      singleton: false,
      viewportFixedPosition: false,
      insertButton: true,
      insertAt: null,
      blocksLabel: null,
      blocksPresentation: null,
      sample: {
        settings: {
          title: 'My awesome title',
          image: '/theme/image-placeholder.jpg',
        },
        blocks: [
          {
            type: 'list_item',
            settings: {
              title: 'Item title',
              image: '/theme/image-placeholder.jpg',
            },
          },
        ],
      },
      settings: [
        {
          id: 'title',
          label: 'My awesome title',
          type: 'text',
          default: 'My awesome title',
          options: {},
        },
        {
          id: 'image',
          label: 'An image',
          type: 'image',
          default: '/theme/image-placeholder.jpg',
          options: {},
        },
        {
          id: 'product',
          label: 'Highlighted Product',
          type: 'collection_item',
          options: { collectionId: 'products' },
        },
        {
          id: 'cta',
          label: 'Call to action',
          type: 'link',
          default: '#',
          options: { withText: true },
        },
        {
          id: 'background_color',
          label: 'Background color',
          type: 'color',
          options: {
            presets: ['#FEE2E2', '#FEF3C7', '#D1FAE5', '#DBEAFE', '#FFFFFF'],
            advanced: true,
          },
        },
      ],
      blocks: [
        {
          name: 'List item',
          type: 'list_item',
          root: true,
          settings: [
            {
              id: 'title',
              label: 'Item title',
              type: 'text',
              default: 'Item title',
              options: {},
            },
            {
              id: 'image',
              label: 'Item image',
              type: 'image',
              default: '/theme/image-placeholder.jpg',
              options: {},
            },
          ],
        },
      ],
      themeId: 'theme',
      screenshotPath: '/theme/highlighted_product_01.jpg?1629383117',
    },
  ],
  sectionCategories: [
    { name: 'Heroes', id: 'heroes' },
    { name: 'Navbars', id: 'navbars' },
    { name: 'Calls to action', id: 'cta' },
    { name: 'Contents', id: 'contents' },
    { name: 'Carousels', id: 'carousels' },
    { name: 'Lists', id: 'lists' },
    { name: 'Footers', id: 'footers' },
  ],
  icons: [
    'icon-af-arrow-circle-down',
    'icon-af-arrow-circle-left',
    'icon-af-arrow-circle-right',
    'icon-af-arrow-circle-top',
    'icon-af-arrow-slider-left',
    'icon-af-arrow-slider-right',
    'icon-af-bulle',
    'icon-af-cart',
    'icon-af-certif',
    'icon-af-counter',
    'icon-af-envelope',
    'icon-af-files',
    'icon-af-gabarit-icon',
    'icon-af-headphone',
    'icon-af-home-2',
    'icon-af-home',
    'icon-af-map',
    'icon-af-phone',
    'icon-af-print',
    'icon-af-scoot-ip',
    'icon-arrow-fine-east',
    'icon-arrow-fine-north',
    'icon-arrow-fine-south',
    'icon-arrow-fine-west',
    'icon-arrow-l',
    'icon-arrow-r',
    'icon-circle-fine',
    'icon-circle-folder-paper',
    'icon-circle-hearth',
    'icon-development',
    'icon-folder-paper',
    'icon-graphisme',
    'icon-icon-career-2',
    'icon-icon-careers',
    'icon-iconmonstr-help-4-icon',
    'icon-iconmonstr-help-6-icon',
    'icon-iconmonstr-linux-os-icon',
    'icon-iconmonstr-logout-5-icon',
    'icon-iconmonstr-monitoring-2-icon',
    'icon-iconmonstr-monitoring-icon',
    'icon-iconmonstr-printer-2-icon',
    'icon-iconmonstr-printer-7-icon',
    'icon-iconmonstr-share-2-icon',
    'icon-iconmonstr-shipping-box-12-icon',
    'icon-iconmonstr-target-3-icon',
    'icon-iconmonstr-tools-10-icon',
    'icon-iconmonstr-tv-5-icon',
    'icon-iconmonstr-tv-6-icon',
    'icon-iconmonstr-windows-os-icon',
    'icon-minus',
    'icon-pattent',
    'icon-press',
    'icon-quality',
    'icon-reload',
    'icon-sav',
    'icon-search-right',
    'icon-search',
    'icon-seo',
    'icon-shop',
    'icon-workshop',
  ],
}
