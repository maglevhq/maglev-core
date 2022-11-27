import PagePreview from '@/views/page-preview.vue'
import EditStylePane from '@/views/style/edit-pane.vue'

export default [
  {
    path: 'style',
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
