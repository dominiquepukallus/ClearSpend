import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  open() {
    this.modalTarget.classList.add("dashboard-modal--open")
    this.modalTarget.removeAttribute("aria-hidden")
    document.body.classList.add("dashboard-modal-open")
  }

  close() {
    this.modalTarget.classList.remove("dashboard-modal--open")
    this.modalTarget.setAttribute("aria-hidden", "true")
    document.body.classList.remove("dashboard-modal-open")
  }

  closeWithKeyboard(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }
}
