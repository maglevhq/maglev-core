import PagePreview from '@/views/page-preview'
import ContentPane from '@/views/content-pane'
import SectionListPane from '@/views/section-list-pane'

export default [
  {
    path: 'sections',
    name: 'listSections',
    components: {
      default: PagePreview,
      'slide-pane': SectionListPane,
    },
    props: { 
      'slide-pane': true,
      default: true 
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
      default: true 
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
    ]
  },
]