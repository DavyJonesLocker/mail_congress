$(function() {
  new Highcharts.Chart({
    chart: { renderTo: 'chart' },
    title: { text: 'Performance' },
    xAxis: {
      type: 'dateTime',
      categories: activity_days 
    },
    yAxis: {
      title: { text: '' }
    },
    series: [
    {  
      name: 'Letter sent',
      data: letters_sent
    },
    {
      name: 'Follow ups made',
      data: follow_ups_made
    }]
  });
});
