import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["filename", "submit"]

  connect() {
    this.element.addEventListener('turbo:frame-render', () => this.stopLoading())
  }

  showFilename(event) {
    const file = event.target.files[0]
    if (file) {
      this.filenameTarget.textContent = `Selected ${file.name}`
      this.filenameTarget.classList.remove('hidden')
    }
  }

  startLoading(event) {
    if (!this.hasSubmitTarget) return

    this.originalText = this.submitTarget.value || this.submitTarget.textContent
    const loadingText = this.submitTarget.dataset.loadingText || "Loading.."

    this.submitTarget.disabled = true
    this.submitTarget.classList.add("is-loading")
    if (this.submitTarget.tagName === "INPUT") {
      this.submitTarget.value = loadingText
    } else {
      this.submitTarget.textContent = loadingText
    }
  }

  stopLoading(event) {
    if (!this.hasSubmitTarget) return

    this.submitTarget.disabled = false
    this.submitTarget.classList.remove("is-loading")
    if (this.submitTarget.tagName === "INPUT") {
      this.submitTarget.value = this.originalText
    } else {
      this.submitTarget.textContent = this.originalText
    }
  }
}
