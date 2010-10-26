$(function() {
  $('ul.legislators img').click(function() { toggleLegislator($(this).parent().parent()) });
  $('ul.legislators label').click(function() { toggleLegislator($(this).parent()); });
});

function toggleLegislator(list_item) {
  toggleImage(list_item);
  updateCost();
}

function toggleImage(list_item) {
  var image = list_item.find('img');
  var id    = list_item.find('.legislator_id')
  if (id.attr('disabled')) {
    image.removeClass('monochrome');
    image.addClass('color');
    id.attr('disabled', null)
  } else {
    image.removeClass('color');
    image.addClass('monochrome');
    id.attr('disabled', 'disabled')
  }
}

function updateCost() {
  var total = 0;
  $('ul.legislators .legislator_id').each(function() {
    if (!this.disabled) {
     total += 1;
    }
  });
  switch(total) {
    case 0:
      var cost_html = "$0 no legislators chosen.";
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
