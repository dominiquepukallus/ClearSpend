import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  connect() {
    this.nextIndex = 1
  }

  addRow(event) {
    event.preventDefault()
    let template = this.templateTarget.innerHTML
    template = template.replace(/INDEX/g, this.nextIndex)
    template = template.replace(/NEW/g, this.nextIndex + 1)
    this.containerTarget.insertAdjacentHTML('beforeend', template)
    this.nextIndex++
  }

  removeRow(event) {
    event.preventDefault()
    const row = event.target.closest('[data-bulk-subscription-row]')
    if (this.containerTarget.children.length > 1) {
      row.remove()
    } else {
      alert("You need at least one subscription!")
    }
  }
}
