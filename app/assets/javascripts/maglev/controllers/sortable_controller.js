import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from '@rails/request.js'
import { Sortable, Plugins } from "@shopify/draggable"

export default class extends Controller {
  static targets = ["item"]
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
    const formData = new FormData()
    this.itemTargets.forEach(item => {  
      formData.append('item_ids[]', item.dataset.itemId)
    })
    
    const request = new FetchRequest('put', this.pathValue, { body: formData })
    return request.perform()
  }

  disconnect() {
    this.sortable.destroy()
  }
}