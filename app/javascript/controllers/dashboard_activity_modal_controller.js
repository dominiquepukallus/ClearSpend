import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "title", "activityGrid", "addedSection"]

  open(event) {
    this.setMode(event.params.view || "activity")
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

  setMode(view) {
    const cancelledOnly = view === "cancelled"

    this.titleTarget.textContent = cancelledOnly ? "Cancelled subscriptions" : "Monthly activity"
    this.activityGridTarget.classList.toggle("dashboard-activity-grid--cancelled", cancelledOnly)
    this.addedSectionTarget.hidden = cancelledOnly
  }
}
