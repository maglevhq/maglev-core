
import { StreamActions } from '@hotwired/turbo'
import TurboDelayedStreams from 'maglev-patches/turbo_delayed_streams'

// Custom stream actions
StreamActions.console_log = function() {
  const message = this.getAttribute("message")
  console.log(message)
}

StreamActions.dispatch_event = function() {
  const type = this.getAttribute("type")
  const payload = this.getAttribute("payload")
  console.log('dispatchEvent', type, payload, `dispatcher:${type}`)
  const event = new CustomEvent(`dispatcher:${type}`, { detail: JSON.parse(payload) })
  window.dispatchEvent(event)
}

// Handle delayed streams through Turbo events

document.addEventListener("turbo:before-stream-render", (event) => {
  const delayedStream = event.detail.newStream.templateContent.querySelector('meta[name="turbo-delayed-stream"]')?.content === 'true'
  const requestId = event.detail.newStream.templateContent.querySelector('meta[name="turbo-request-id"]')?.content

  if (delayedStream) {
    // Keep the stream in the queue to be rendered later
    TurboDelayedStreams.add(requestId, () => {
      event.detail.render(event.detail.newStream)
    })
          
    // Cancel Turbo's rendering for this stream
    event.preventDefault()
  }    
})

document.addEventListener('turbo:before-fetch-request', (event) => {
  const requestId = crypto.randomUUID()

  // Attach to headers (for server → client stream correlation)
  event.detail.fetchOptions.headers["X-Turbo-Request-ID"] = requestId

  // Attach to the fetchRequest instance
  event.detail.fetchOptions.turboRequestId = requestId
})