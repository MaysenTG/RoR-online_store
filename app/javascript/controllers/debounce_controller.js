import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Debounce controller connected");
  }

  static targets = ["form"];

  search() {
    document.querySelector("#search-loading-spinner").classList.remove("d-none");
    
  
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit();
      document.querySelector("#search-loading-spinner").classList.add("d-none");
    }, 500);
  }
}
