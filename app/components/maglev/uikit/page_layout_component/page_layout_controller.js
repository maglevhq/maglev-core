import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  
  vtPair(event) {
    const oldDoc = document
    const newBody = event.detail.newBody

    const hadPageLayout = !!oldDoc.querySelector('#page-layout')
    const hasPageLayout = !!newBody.querySelector('#page-layout')
    const hasExpandedPageLayout = !!newBody.querySelector('#page-layout[data-expanded]')

    if (hasExpandedPageLayout) {
      document.documentElement.dataset.expandedPageLayout = true
    } else {
      delete document.documentElement.dataset.expandedPageLayout
    }

    if (hadPageLayout && hasPageLayout) {
      document.documentElement.dataset.pageLayoutVtPair = "already-present"
    } else {
      delete document.documentElement.dataset.pageLayoutVtPair
    }
  }
}