$(document).ready(function () {

const ctx = document.getElementById('myChart');

new Chart(ctx, {
  type: 'doughnut',
  data: {
    labels: [ 'Progress','left to study'],
    datasets: [{
      data: [40, 60],
      backgroundColor: ['rgba(75, 192, 192, 0.8)', 'rgba(255, 99, 132, 0.8)'],
      borderWidth: 1
    }]
  },
  options: {
    responsive: true,
    maintainAspectRatio: true,
    legend: {
      display: true,
      position: 'right',
    }
  }
});

});
