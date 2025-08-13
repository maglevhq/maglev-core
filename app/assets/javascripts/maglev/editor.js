import "@hotwired/turbo-rails"
import "maglev-controllers"

console.log('Maglev Editor v2 ⚡️')

// This is a hack to prevent the view transition from being triggered when clicking on a link with the same pathname and search
document.addEventListener("click", (event) => {
  const link = event.target.closest("a[href]");
  if (!link) return;

  const current = new URL(window.location.href);
  const target  = new URL(link.href, window.location.origin);

  if (current.pathname === target.pathname && current.search === target.search) {
    link.dataset.turboAction = "replace";
  }
});