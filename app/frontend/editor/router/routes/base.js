import AppLayout from '@/layouts/app.vue'
import PagePreview from '@/views/page-preview.vue'
import SlidePane from '@/views/slide-pane.vue'
import SlidePane2 from '@/views/slide-pane2.vue'
import pageRoutes from './page'
import sectionRoutes from './section'
import sectionBlockRoutes from './section-block'
import styleRoutes from './style'

export default [
  {
    path: '/',
    name: 'home',
    redirect: '/index',
  },
  {
    path: '/:locale/:pageId',
    component: AppLayout,
    children: [
      {
        path: '',
        name: 'editPage',
        components: {
          default: PagePreview,
        },
        props: { default: true },
      },
    ],
  },
  {
    path: '/:locale/:pageId/_',
    component: AppLayout,
    children: [
      {
        path: 'foo-test',
        name: 'test',
        components: {
          default: PagePreview,
          'slide-pane': SlidePane,
        },
        props: { default: true },
        meta: { hidingSidebar: true },
      },
      {
        path: 'foo-test2',
        name: 'test2',
        components: {
          default: PagePreview,
          'slide-pane': SlidePane2,
        },
        props: { default: true },
      },
      ...pageRoutes,
      ...sectionRoutes,
      ...sectionBlockRoutes,
      ...styleRoutes,
    ],
  },
]
