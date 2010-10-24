$(function() {
  $('.rep-choice').change(updateCost);
  $('#letter_body').wysiwyg();
});

function updateCost() {
  var total = 0;
  $('.rep-choice').each(function() {
    if (this.checked) {
      total += 1;
    }
  });
  switch(total) {
    case 0:
      var cost_html = "";
      break;
    
    case 1:
      var cost_html = "$1 to send this letter.";
      break;

    default:
      var cost_html = "$" + total + " to send these letters.";
      break;
  }
  $('h2.cost').text(cost_html);
}
