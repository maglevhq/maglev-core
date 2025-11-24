import "@hotwired/turbo-rails"
import "maglev-controllers"
import "maglev-patches/page_renderer_patch"
import "maglev-patches/turbo_stream_patch"

console.log('Maglev Editor v2 ⚡️')

// We need to set the content locale in the headers for each Turbo request
document.addEventListener("turbo:before-fetch-request", (event) => {
  const { fetchOptions } = event.detail
  const contentLocale = document.querySelector("meta[name=content-locale]").content
  fetchOptions.headers["X-MAGLEV-LOCALE"] = contentLocale
});

// This is a hack to prevent the view transition from being triggered when clicking on a link with the same pathname and search
document.addEventListener("click", (event) => {
  const link = event.target.closest("a[href]")
  if (!link) return

  const current = new URL(window.location.href)
  const target  = new URL(link.href, window.location.origin)

  if (current.pathname === target.pathname && current.search === target.search) {
    console.log('same link clicked!!!')
    link.dataset.turboAction = "replace"
  }
})