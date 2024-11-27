import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="interaction"
export default class extends Controller {
  static targets = [ "output" ]

  initialize() {
    this.outputTarget.textContent = "Aguardando ação..."
  }

  changeContent() {
    this.outputTarget.textContent = "Conteúdo alterado pelo Stimulus!"
  }
}