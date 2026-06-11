import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "menu", "label", "input"]

  connect() {
    this.open = false
    document.addEventListener("click", this.handleOutsideClick.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick.bind(this))
  }

  toggle() {
    this.open = !this.open
    this.menuTarget.classList.toggle("hidden", !this.open)
  }

  select(event) {
    const value = event.currentTarget.dataset.value
    const label = event.currentTarget.dataset.label
    this.labelTarget.textContent = label
    this.inputTarget.value = value
    this.menuTarget.classList.add("hidden")
    this.open = false
    this.inputTarget.form.submit()
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
      this.open = false
    }
  }

  resetToToday() {
    const today = new Date()
    const value = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}`
    const form = this.element.querySelector('form')
    const input = document.createElement('input')
    input.type = 'hidden'
    input.name = 'month'
    input.value = value
    form.appendChild(input)
    form.requestSubmit()
  }

  resetSort() {
  const input = this.inputTarget
  input.value = ""
  const label = this.labelTarget
  if (label) label.textContent = "Sort by"
  input.closest('form').requestSubmit()
  }
}
