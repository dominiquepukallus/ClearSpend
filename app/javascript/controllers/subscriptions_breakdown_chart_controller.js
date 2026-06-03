import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static targets = ["canvas"]
  static values = {
    labels: Array,
    values: Array,
    colors: Array,
    total: Number
  }

  connect() {
    this.renderChart()
  }

  disconnect() {
    this.chart?.destroy()
  }

  renderChart() {
    this.chart?.destroy()

    const labels = this.labelsValue.length ? this.labelsValue : ["No subscriptions"]
    const values = this.valuesValue.length ? this.valuesValue : [1]
    const colors = this.valuesValue.length ? this.colorsValue : ["#edf0f5"]
    const total = this.totalValue

    this.chart = new Chart(this.canvasTarget, {
      type: "doughnut",
      data: {
        labels,
        datasets: [{
          data: values,
          backgroundColor: colors,
          borderWidth: 0,
          hoverOffset: 6,
          spacing: 0
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        cutout: "62%",
        animation: {
          duration: 500
        },
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            callbacks: {
              label: (context) => {
                const value = Number(context.parsed || 0)
                return `${context.label}: ${this.formatCurrency(value)}`
              }
            }
          }
        }
      },
      plugins: [this.centerTotalPlugin(total)]
    })
  }

  centerTotalPlugin(total) {
    return {
      id: "centerTotal",
      beforeDraw: (chart) => {
        const { ctx, chartArea } = chart

        ctx.save()
        ctx.font = "700 24px system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif"
        ctx.fillStyle = "#1f2328"
        ctx.textAlign = "center"
        ctx.textBaseline = "middle"
        ctx.fillText(this.formatCurrency(total), (chartArea.left + chartArea.right) / 2, (chartArea.top + chartArea.bottom) / 2)
        ctx.restore()
      }
    }
  }

  formatCurrency(value) {
    return new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "USD",
      maximumFractionDigits: 0
    }).format(value)
  }
}
