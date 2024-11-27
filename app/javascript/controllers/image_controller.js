import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from 'chart.js'

Chart.register(...registerables)

export default class extends Controller {
  static targets = ['canvas']

  connect() {
    this.chart = null
  }

  async generateReport(event) {
    event.preventDefault(); // Previne o comportamento padrão do link

    const ctx = this.canvasTarget.getContext('2d');
    const data = JSON.parse(this.canvasTarget.dataset.chartData || '{}');
    if (!this.chart) {
      this.chart = new Chart(ctx, {
        type: 'doughnut',  // Altere para 'doughnut' para gráfico de dona
        data: {
          labels: Object.keys(data), // Rótulos do gráfico
          datasets: [{
            label: 'Proponentes', // Legenda do gráfico
            data: Object.values(data), // Valores do gráfico
            backgroundColor: [
              'rgba(255, 99, 132, 0.2)',
              'rgba(54, 162, 235, 0.2)',
              'rgba(255, 206, 86, 0.2)',
              'rgba(75, 192, 192, 0.2)'
            ],
            borderColor: [
              'rgba(255, 99, 132, 1)',
              'rgba(54, 162, 235, 1)',
              'rgba(255, 206, 86, 1)',
              'rgba(75, 192, 192, 1)'
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
    } else {
      this.chart.update();
    }

    setTimeout(() => {
      this.canvasTarget.toBlob((blob) => {
        this.sendImageToServer(blob);
        this.createReport();
      }, 'image/png');
    }, 7000);

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
