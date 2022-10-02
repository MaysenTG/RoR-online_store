import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    //this.element.textContent = "Hello World!"
    console.log("Hello World! from Hello controller")
  }
  
  change(event) {
    console.log("Changed")
    console.log(event)
  }
}
