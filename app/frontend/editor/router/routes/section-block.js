import PagePreview from '@/views/page-preview.vue'
import ContentPane from '@/views/content-pane.vue'

export default [
  {
    path: 'sectionBlock/:sectionBlockId',
    name: 'editSectionBlock',
    components: {
      default: PagePreview,
      'slide-pane': ContentPane,
    },
    props: {
      'slide-pane': true,
      default: true,
    },
    meta: { hidingSidebar: true },
    children: [
      {
        path: 'setting/:settingId',
        name: 'editSectionBlockSetting',
        components: {
          default: PagePreview,
          'slide-pane': ContentPane,
        },
        meta: { hidingSidebar: true },
      },
    ],
  },
]
