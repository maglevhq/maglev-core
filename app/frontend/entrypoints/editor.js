console.log('Maglev Editor ⚡️')

import Editor from '~/editor/main'
import '~/editor/design/application.scss'

document.addEventListener('DOMContentLoaded', () => {
  Editor.start()
})
