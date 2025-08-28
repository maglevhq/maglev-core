import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  
  vtPair(event) {
    console.log('PageLayoutComponentController vtPair', event)

    const oldDoc = document
    const newBody = event.detail.newBody

    const hadAppLayout = !!oldDoc.querySelector('#drawer-component')
    const hasAppLayout = !!newBody.querySelector('#drawer-component')

    if (hadAppLayout && hasAppLayout) {
      document.documentElement.dataset.appLayoutVtPair = "already-present"
    } else {
      delete document.documentElement.dataset.appLayoutVtPair
    }
  }
}