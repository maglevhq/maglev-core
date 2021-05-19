import PagePreview from '@/views/page-preview'
import PageList from '@/views/pages/index'

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
      default: true
    },
  },
]