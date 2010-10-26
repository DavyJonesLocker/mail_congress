$(function() {
  $('ul.legislators :checkbox').change(function() { toggleLegislator(this); });
  $('#letter_body').wysiwyg();
  $('img').click(function() { toggleRep(this); });
});

function toggleLegislator(checkbox) {
  updateCost();
  toggleImage(checkbox);
}

function toggleImage(checkbox) {
  var image = $(checkbox).parent().find('img');
  if (checkbox.checked) {
    image.removeClass('monochrome');
    image.addClass('color');
  } else {
    image.removeClass('color');
    image.addClass('monochrome');
  }
}

function updateCost() {
  var total = 0;
  $('ul.legislators :checkbox').each(function() {
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

function toggleRep(image) {
  var checkbox = $(image).parent().parent().find(':checkbox');
  checkbox.attr('checked', !checkbox.is(':checked'));
  checkbox.trigger('change');
}
