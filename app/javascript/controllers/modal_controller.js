import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    document.addEventListener("turbo:frame-load", this.handleFrameLoad.bind(this))
    document.addEventListener("keydown", this.handleKeydown.bind(this))
  }

  disconnect() {
    document.removeEventListener("turbo:frame-load", this.handleFrameLoad.bind(this))
    document.removeEventListener("keydown", this.handleKeydown.bind(this))
  }

  handleFrameLoad(event) {
    if (event.target.id === "modal_content") {
      this.open()
    }
  }

  handleKeydown(event) {
    if (event.key === "Escape") this.close()
  }

  open() {
    this.containerTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")
  }

  close() {
    this.containerTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
    document.getElementById("modal_content").innerHTML = ""
  }
}
