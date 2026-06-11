import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static targets = ["canvas"]
  static values = {
    labels: Array,
    fullLabels: Array,
    values: Array
  }

  connect() {
    this.renderChart()
  }

  disconnect() {
    this.chart?.destroy()
  }

  renderChart() {
    this.chart?.destroy()

    this.chart = new Chart(this.canvasTarget, {
      type: "line",
      data: {
        labels: this.labelsValue,
        datasets: [{
          data: this.valuesValue,
          borderColor: "#1b2b4b",
          backgroundColor: "rgba(27, 43, 75, 0.12)",
          borderWidth: 2,
          pointBackgroundColor: "#ffffff",
          pointBorderColor: "#1b2b4b",
          pointBorderWidth: 2,
          pointRadius: 3,
          pointHoverRadius: 5,
          tension: 0.35,
          fill: true
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: {
          intersect: false,
          mode: "index"
        },
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            callbacks: {
              title: (items) => {
                const index = items[0]?.dataIndex
                return this.fullLabelsValue[index] || this.labelsValue[index] || ""
              },
              label: (context) => {
                const value = Number(context.parsed.y || 0)
                return `Monthly spend: ${this.formatCurrency(value)}`
              }
            }
          }
        },
        scales: {
          x: {
            grid: {
              display: false
            },
            border: {
              display: false
            },
            ticks: {
              autoSkip: true,
              maxRotation: 0,
              maxTicksLimit: 12,
              color: "#7d83a6",
              font: {
                size: 10,
                weight: "normal"
              }
            }
          },
          y: {
            display: false,
            beginAtZero: true
          }
        }
      }
    })
  }

  formatCurrency(value) {
    return new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "USD",
      maximumFractionDigits: 0
    }).format(value)
  }
}
