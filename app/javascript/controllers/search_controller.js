import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "item"]

  filter() {
    const query = this.inputTarget.value.toLowerCase()
    this.itemTargets.forEach(item => {
      const name = item.dataset.name.toLowerCase()
      item.hidden = !name.includes(query)
    })
  }
}
