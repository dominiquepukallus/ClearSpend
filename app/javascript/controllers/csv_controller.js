// app/javascript/controllers/csv_upload_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["loading"]

  autoSubmit(event) {
    console.log("File selected")
    if (event.target.files.length > 0) {
      // Show loading message
      if (this.hasLoadingTarget) {
        this.loadingTarget.classList.remove('hidden')
      }

      event.target.closest('form').requestSubmit()
    }
  }
}
