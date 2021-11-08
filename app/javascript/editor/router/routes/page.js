import PagePreview from '@/views/page-preview'
import PageList from '@/views/pages/index'
import EditPage from '@/views/pages/edit'

export default [
  {
    path: '__pages',
    name: 'listPages',
    components: {
      default: PagePreview,
      'slide-pane': PageList,
    },
    props: {
      'slide-pane': true,
      default: true,
    },
  },
  {
    path: 'editSettings',
    name: 'editPageSettings',
    components: {
      default: PagePreview,
      'slide-pane': EditPage,
    },
    props: {
      'slide-pane': true,
      default: true,
    },
  },
]
