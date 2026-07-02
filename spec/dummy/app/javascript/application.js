// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
window.addEventListener('load', () => {
  console.log('dummy theme loaded')
})

window.addEventListener('maglev:page-updated', (event) => {
  console.log('Page updated!', event)
})