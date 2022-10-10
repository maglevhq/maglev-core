import store from '@/store'

export default () => {
  console.log('setting iframePreview up...')

  window.addEventListener('message', function (event) {
    console.log('📡 Editor receiving', event.data)
    switch (event.data.type) {
      case 'hello':
        store.dispatch('markPreviewAsReady')
        break
      default:
        break
    }
  })
}
