// Delayed Turbo streams are streams that are not rendered immediately, but are rendered later manually by the application
// It's used by the SubmitButton controller for instance

class TurboDelayedStream {
  constructor(maxElements = 10) {
    this.maxElements = maxElements
    this.elements = new Map()
  }

  add(requestId, render) {
    if (this.elements.has(requestId)) {
      this.elements.get(requestId).push(render)
    } else {
      this.elements.set(requestId, [render])
    }

    if (this.elements.size > this.maxElements) {
      this.elements.delete(this.elements.keys().next().value)
    }
  }

  render(requestId) {
    if (!this.elements.has(requestId)) return

    const renderFns = this.elements.get(requestId)

    // render all the turbo streams for this request
    renderFns.forEach(render => render())
    
    // remove the element from the list
    this.elements.delete(requestId)
  }
}

export default new TurboDelayedStream()