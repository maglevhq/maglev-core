import "@hotwired/turbo-rails"
import "maglev-controllers"
import { PageRenderer } from '@hotwired/turbo'

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

// class CustomPageRenderer extends PageRenderer {
//   assignNewBody() {
//     document.getElementById('root').replaceWith(this.newElement.querySelector('#root'))
//   }
// }

// Turbo.setRenderer(CustomPageRenderer)

PageRenderer.prototype.assignNewBody = function() {
  const body = document.querySelector("#root")
  const el   = this.newElement.querySelector("#root")

  if (body && el) {
    body.replaceWith(el)
    return
  } else if (document.body && this.newElement instanceof HTMLBodyElement) {
    document.body.replaceWith(this.newElement)
  } else {
    document.documentElement.appendChild(this.newElement)
  }
}

// copied since `util` is not exported
// const nextEventLoopTick = () => new Promise((resolve) => {
//   setTimeout(() => resolve(), 0);
// });

// const findBodyElement = (body) => body.querySelector('#root') || body;

// PageRenderer.prototype.assignNewBody = async function assignNewBody() {
//   await nextEventLoopTick();

//   if (document.body && this.newElement instanceof HTMLBodyElement) {
//     const currentBody = findBodyElement(document.body);
//     const newBody = findBodyElement(this.newElement);

//     console.log('replaceWith 🙌🙌🙌🙌', currentBody, newBody)

//     // currentBody.replaceWith(newBody);
//   } else {
//     document.documentElement.appendChild(this.newElement);
//   }
// };

// window.addEventListener("turbo:before-render", (event) => {
//   console.log('turbo:before-render 🙌🙌🙌🙌', event)

//   const currentBody = document.body
//     const newBody     = event.detail.newBody

//     const currentApp  = currentBody.querySelector("#root")
//     const incomingApp = newBody.querySelector("#root")

//     if (!currentApp || !incomingApp) return // fall back to default

//     // Tell Turbo to use our custom render
//     event.detail.render = (currentElement, newElement) => {
//       const doSwap = () => {
//         // Replace the app container’s children (not the node itself)
//         currentApp.replaceChildren(...incomingApp.childNodes)
//       }

//       // Same-document View Transition so your CSS VT still runs
//       if (document.startViewTransition) {
//         document.startViewTransition(doSwap)
//       } else {
//         doSwap()
//       }
//     }
// })