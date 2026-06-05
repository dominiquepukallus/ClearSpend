import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["filename"]

  showFilename(event) {
    const file = event.target.files[0]
    if (file) {
      this.filenameTarget.textContent = `Selected ${file.name}`
      this.filenameTarget.classList.remove('hidden')
    }
  }
}
