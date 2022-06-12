import PagePreview from '@/views/page-preview'
import EditStylePane from '@/views/style/edit-pane'

export default [
  {
    path: '__style',
    name: 'editStyle',
    components: {
      default: PagePreview,
      'slide-pane': EditStylePane,
    },
    props: {
      'slide-pane': true,
      default: true,
    },
  },
]
