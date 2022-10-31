import PagePreview from '@/views/page-preview.vue'
import ContentPane from '@/views/content-pane.vue'
import SectionAddPane from '@/views/sections/add-pane.vue'
import SectionListPane from '@/views/sections/list-pane.vue'

export default [
  {
    path: 'add-section',
    name: 'addSection',
    components: {
      default: PagePreview,
      'slide-pane': SectionAddPane,
    },
    props: {
      'slide-pane': true,
      default: true,
    },
  },
  {
    path: 'add-section/:sectionId',
    name: 'addSectionAfter',
    components: {
      default: PagePreview,
      'slide-pane': SectionAddPane,
    },
    props: {
      'slide-pane': true,
      default: true,
    },
  },
  {
    path: 'sections',
    name: 'listSections',
    components: {
      default: PagePreview,
      'slide-pane': SectionListPane,
    },
    props: {
      'slide-pane': true,
      default: true,
    },
  },
  {
    path: 'section/:sectionId',
    name: 'editSection',
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
        name: 'editSectionSetting',
        components: {
          default: PagePreview,
          'slide-pane': ContentPane,
        },
        meta: { hidingSidebar: true },
      },
    ],
  },
]
