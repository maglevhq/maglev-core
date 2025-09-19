import { Controller } from "@hotwired/stimulus"
import { Sortable, Plugins } from "@shopify/draggable"

export default class extends Controller {
  static targets = ["sortableForm"]
  static values = { path: String, scope: String }

  connect() {
    this.draggableName = this.scopeValue ? `item-${this.scopeValue}` : 'item'
    const handleName = this.scopeValue ? `handle-${this.scopeValue}` : 'handle'

    this.sortable = new Sortable(this.element, {
      draggable: `[data-sortable-target="${this.draggableName}"]`,
      handle: `[data-sortable-target="${handleName}"]`,
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

    const _emitEvent = this.emitEvent.bind(this)
    const _persist = this.persist.bind(this)
    
    this.sortable.on('sortable:stop', _emitEvent)
    this.sortable.on('drag:stopped', _persist)
  }

  disconnect() {
    this.sortable.destroy()
  }

  emitEvent(event) {
    // optimistic UI update
    const { oldIndex, newIndex } = event.data    
    this.dispatch('drag-stopped', { detail: { oldIndex, newIndex } })
  }

  persist() {
    // persisting the new order in DB
    this.itemTargets().forEach(item => {  
      const hiddenField = document.createElement('input')
      hiddenField.type = 'hidden'
      hiddenField.name = 'item_ids[]'
      hiddenField.value = item.dataset.itemId
      this.sortableFormTarget.appendChild(hiddenField)
    })

    this.sortableFormTarget.requestSubmit()
  }

  itemTargets() {
    return this.element.querySelectorAll(`[data-sortable-target="${this.draggableName}"]`)
  }
}