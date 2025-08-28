import { Controller } from "@hotwired/stimulus"
import { Sortable, Plugins } from "@shopify/draggable"

export default class extends Controller {
  static targets = ["item", "sortableForm"]
  static values = { path: String }

  connect() {
    this.sortable = new Sortable(this.element, {
      draggable: '[data-sortable-target="item"]',
      handle: '[data-sortable-target="handle"]',
      classes: {
        'container:dragging': ['is-dragging'],
        'mirror': ['shadow-md'],
        'source:dragging': ['opacity-50'],
      },
      mirror: {
        appendTo: this.element,
        constrainDimensions: true,
      },
      plugins: [Plugins.SortAnimation],
      swapAnimation: {
        duration: 200,
        easingFunction: 'ease-in-out',
      },
    });

    this.sortable.on('drag:stopped', this.onSorted.bind(this))
  }

  onSorted() {
    this.itemTargets.forEach(item => {  
      const hiddenField = document.createElement('input')
      hiddenField.type = 'hidden'
      hiddenField.name = 'item_ids[]'
      hiddenField.value = item.dataset.itemId
      this.sortableFormTarget.appendChild(hiddenField)
    })
    
    this.sortableFormTarget.requestSubmit()
  }

  disconnect() {
    this.sortable.destroy()
  }
}