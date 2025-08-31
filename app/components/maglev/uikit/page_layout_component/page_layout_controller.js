import { Controller } from '@hotwired/stimulus';

export default class extends Controller {

  connect() {
    this.updateBodyDataset(this.element.dataset.expanded)
  }
  
  vtPair(event) {
    const oldDoc = document
    const newBody = event.detail.newBody

    const hadPageLayout = !!oldDoc.querySelector('#page-layout')
    const hasPageLayout = !!newBody.querySelector('#page-layout')
    const hasExpandedPageLayout = !!newBody.querySelector('#page-layout[data-expanded]')

    this.updateBodyDataset(hasExpandedPageLayout)

    // required for a smoother transition (application.css) between the page layout and the expanded page layout
    if (hadPageLayout && hasPageLayout) {
      document.documentElement.dataset.pageLayoutVtPair = "already-present"
    } else {
      delete document.documentElement.dataset.pageLayoutVtPair
    }
  }

  updateBodyDataset(expanded) {
    if (expanded === undefined || expanded === false) {
      delete document.body.dataset.expandedPageLayout      
    } else {
      document.body.dataset.expandedPageLayout = true
    }
  }
}