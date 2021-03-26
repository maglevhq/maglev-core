import sectionRoutes from './section'
import sectionBlockRoutes from './section-block'
import AppLayout from '@/layouts/app'
import PagePreview from '@/views/page-preview'
import SlidePane from '@/views/slide-pane'
import SlidePane2 from '@/views/slide-pane2'

export default [
  {
    path: '/',
    name: 'home',
    redirect: '/index',
  },
  {
    path: '/:pageId',
    component: AppLayout,   
    children: [
      {
        path: '',
        name: 'editPage',
        components: {
          default: PagePreview
        },
        props: { default: true }
      },            
      {
        path: 'foo-test',
        name: 'test',
        components: {
          default: PagePreview,
          'slide-pane': SlidePane
        },    
        props: { default: true },
        meta: { hidingSidebar: true },
      },
      {
        path: 'foo-test2',
        name: 'test2',
        components: {
          default: PagePreview,
          'slide-pane': SlidePane2
        },
        props: { default: true }
      },
      ...sectionRoutes,
      ...sectionBlockRoutes,
    ]
  },  
]