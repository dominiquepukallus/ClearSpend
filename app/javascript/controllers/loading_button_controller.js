import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  start() {
    this.button = this.element.querySelector("button[type='submit'], input[type='submit']")
    if (!this.button) return

    this.originalText = this.button.tagName === "INPUT" ? this.button.value : this.button.textContent
    const loadingText = this.button.dataset.loadingText || "Loading..."

    this.button.disabled = true
    this.button.classList.add("is-loading")
    if (this.button.tagName === "INPUT") {
      this.button.value = loadingText
    } else {
      this.button.textContent = loadingText
    }
  }

  stop() {
    if (!this.button) return

    this.button.disabled = false
    this.button.classList.remove("is-loading")
    if (this.button.tagName === "INPUT") {
      this.button.value = this.originalText
    } else {
      this.button.textContent = this.originalText
    }
  }
}
