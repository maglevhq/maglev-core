import PagePreview from '@/views/page-preview.vue'
import PageList from '@/views/pages/index.vue'
import EditPage from '@/views/pages/edit.vue'

export default [
  {
    path: 'pages',
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
