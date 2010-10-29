$(function() {
  $('ul.legislators .bioguide').click(function() { toggleLegislator($(this).parent()) });
  $('ul.legislators label').click(function() { toggleLegislator($(this).parent()); });
});

function toggleLegislator(list_item) {
  toggleBioguide(list_item);
  updateCost();
}

function toggleBioguide(list_item) {
  var bioguide = list_item.find('.bioguide'),
      id       = list_item.find('.legislator_id'),
      mail   = list_item.find('img.mail');

  if (id.attr('disabled')) {
    bioguide.removeClass('monochrome');
    bioguide.addClass('color');
    id.attr('disabled', null);
    mail.fadeIn();
  } else {
    bioguide.removeClass('color');
    bioguide.addClass('monochrome');
    id.attr('disabled', 'disabled');
    mail.fadeOut();
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
