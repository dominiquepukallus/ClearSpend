import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["loading", "container"]

  autoSubmit(event) {
    console.log("File selected")
    if (event.target.files.length > 0) {

      if (this.hasLoadingTarget) {
        this.loadingTarget.classList.remove('hidden')
      }

      event.target.closest('form').requestSubmit()
    }
  }
  removeRow(event) {
    event.preventDefault()
    const row = event.target.closest('[data-preview-table-row]')
    if (row && this.containerTarget.children.length > 1) {
      row.remove()
    } else {
      alert("You need at least one subscription!")
    }
  }
}
