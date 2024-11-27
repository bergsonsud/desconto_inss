import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from 'chart.js'

Chart.register(...registerables)

export default class extends Controller {
  static targets = ['canvas']

  connect() {
    const ctx = this.canvasTarget.getContext('2d')
    this.chart = new Chart(ctx, {
      type: 'doughnut',  // Altere para 'doughnut' para gráfico de dona
      data: {
        labels: ['January', 'February', 'March', 'April', 'May', 'Juane'], // Rótulos dos segmentos
        datasets: [{
          label: 'Sample Data',
          data: [65, 59, 80, 81, 56, 55], // Dados para o gráfico
          backgroundColor: [
            'rgba(255, 99, 132, 0.2)',
            'rgba(54, 162, 235, 0.2)',
            'rgba(255, 206, 86, 0.2)',
            'rgba(75, 192, 192, 0.2)',
            'rgba(153, 102, 255, 0.2)',
            'rgba(255, 159, 64, 0.2)'
          ],
          borderColor: [
            'rgba(255, 99, 132, 1)',
            'rgba(54, 162, 235, 1)',
            'rgba(255, 206, 86, 1)',
            'rgba(75, 192, 192, 1)',
            'rgba(153, 102, 255, 1)',
            'rgba(255, 159, 64, 1)'
          ],
          borderWidth: 1 // Largura da borda
        }]
      },
      options: {
        responsive: true, // Gráfico responsivo
        plugins: {
          legend: {
            position: 'top', // Posição da legenda
          },
          tooltip: {
            callbacks: {
              label: function(tooltipItem) {
                return `${tooltipItem.label}: ${tooltipItem.raw}%`; // Personalização do tooltip
              }
            }
          }
        }
      }
    })
  }

  disconnect() {
    this.chart.destroy()
  }

  async generateReport(event) {
    setTimeout(() => {
      this.canvasTarget.toBlob((blob) => {
        this.sendImageToServer(blob);
        this.createReport();
      }, 'image/png');
    }, 5000);
  }

  sendImageToServer(blob) {
    // Criar um FormData para enviar o arquivo binário
    const formData = new FormData();
    formData.append("image", blob, "report_image.png");

    fetch('/proponents/save_report_image', {
      method: 'POST',
      body: formData,
    })
      .then(response => response.json())
      .then(data => {
        console.log(data.message); // Exibe a mensagem de sucesso ou erro
      })
      .catch(error => {
        console.error("Erro ao enviar a imagem:", error);
      });
  }

  async createReport() {
    fetch("/proponents/generate_report", {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      }
    })
      .then(response => response.json())
      .then(data => {
        if (data.error) {
          console.error("Erro ao gerar o relatório:", data.error)
        } else {
          console.log("Relatório gerado com sucesso:", data.url)
        }
      })
      .catch(error => {
        console.error("Erro ao gerar o relatório:", error)
      })
  }
}
