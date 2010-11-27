$(function() {
  new Highcharts.Chart({
    chart: { renderTo: 'chart' },
    title: { text: 'Campaign 1' },
    xAxis: { type: 'dateTime' },
    yAxis: {
      title: { text: '' }
    },
    series: [{  
      name: 'Letter Written',
      data: [1, 2, 5, 7, 3]
    }]
  });
});
