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
    } else if (!hadAppLayout && hasAppLayout) {
      document.documentElement.dataset.appLayoutVtPair = "first-time-present"
    } else {
      delete document.documentElement.dataset.appLayoutVtPair
    }

    // if (hadAppLayout && !hasAppLayout) {
    //   document.documentElement.dataset.vtPair = "";
    // } else if (!hadAppLayout && hasAppLayout) {
    //   document.documentElement.dataset.vtPair = "expanded-to-compact";
    // } else {
    //   delete document.documentElement.dataset.vtPair;
    // }

    // if (!hadExpanded && hasExpanded) {
    //   document.documentElement.dataset.vtPair = "compact-to-expanded";
    // } else if (hadExpanded && !hasExpanded) {
    //   document.documentElement.dataset.vtPair = "expanded-to-compact";
    // } else {
    //   delete document.documentElement.dataset.vtPair;
    // }
  }
}