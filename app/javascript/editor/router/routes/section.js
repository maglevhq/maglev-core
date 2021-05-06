import PagePreview from '@/views/page-preview'
import ContentPane from '@/views/content-pane'
import SectionAddPane from '@/views/sections/add-pane'
import SectionListPane from '@/views/sections/list-pane'

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
      default: true 
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