import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "activityGrid", "addedSection", "canceledSection"]

  connect() {
    this.handleScroll = this.onScroll.bind(this)
    window.addEventListener("scroll", this.handleScroll)
  }

  disconnect() {
    window.removeEventListener("scroll", this.handleScroll)
  }

  onScroll() {
    document.body.classList.toggle("dashboard-scrolled", window.scrollY > 10)
  }

  open(event) {
    this.setMode(event.params.view || "activity")
    this.modalTarget.classList.remove("hidden")
    this.modalTarget.classList.add("flex")
    this.modalTarget.removeAttribute("aria-hidden")
    document.body.classList.add("overflow-hidden")
  }

  close() {
    this.modalTarget.classList.add("hidden")
    this.modalTarget.classList.remove("flex")
    this.modalTarget.setAttribute("aria-hidden", "true")
    document.body.classList.remove("overflow-hidden")
  }

  closeWithKeyboard(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  setMode(view) {
    const cancelledOnly = view === "cancelled"
    const subscribedOnly = view === "subscribed"
    this.activityGridTarget.classList.toggle("dashboard-activity-grid--cancelled", cancelledOnly || subscribedOnly)
    this.addedSectionTarget.hidden = cancelledOnly
    this.canceledSectionTarget.hidden = subscribedOnly
  }
}
