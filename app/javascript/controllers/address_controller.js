import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'street', 'neighborhood', 'city', 'state' ]

  async change_event(event) {
    const zipcode = event.target.value

    fetch(`https://viacep.com.br/ws/${zipcode}/json/`, {
      headers: { accept: 'application/json'}
    }).then((response) => response.json())
      .then(data => {
        if(data.erro){
          alert('CEP Inválido')
          return
        }
        if(data){
          this.streetTarget.value = data.logradouro
          this.neighborhoodTarget.value = data.bairro
          this.cityTarget.value = data.localidade
          this.stateTarget.value = data.uf
        }
      }).catch(reason => {
      alert('CEP Inválido')
    })
  }
}
