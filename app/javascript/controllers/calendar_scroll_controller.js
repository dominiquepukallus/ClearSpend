import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { prev: String, next: String, current: String }

  connect() {
    this.handleWheel = this.handleWheel.bind(this)
    this.element.addEventListener("wheel", this.handleWheel, { passive: false })
    this._cooldown = false
  }

  disconnect() {
    this.element.removeEventListener("wheel", this.handleWheel)
  }

  handleWheel(event) {
    event.preventDefault()
    if (this._cooldown) return
    if (Math.abs(event.deltaY) < 10) return

    const goingBack = event.deltaY < 0

    if (goingBack) {
      const current = new Date(this.currentValue)
      const twoYearsAgo = new Date()
      twoYearsAgo.setFullYear(twoYearsAgo.getFullYear() - 2)
      twoYearsAgo.setDate(1)
      if (current <= twoYearsAgo) return
    }

    this._cooldown = true
    setTimeout(() => this._cooldown = false, 1000)

    const url = event.deltaY > 0 ? this.nextValue : this.prevValue
    const frame = document.querySelector('turbo-frame#calendar')
    if (frame) frame.src = url
  }
}
