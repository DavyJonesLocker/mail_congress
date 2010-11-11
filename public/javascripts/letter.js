$(function() {
  $('ul.legislators .bioguide').click(function() { toggleLegislator($(this).parent()) });
  $('ul.legislators label').click(function() { toggleLegislator($(this).parent()); });
  $('.preview').keyup(showLetterPreview);
  updateCost();
  showLetterPreview();
});

function showLetterPreview() {
  var present = true;
  $.each($('.preview'), function(index, input) {
    // This crazy conditional is necessary for Capybara-Envjs...
    // Capybara-Envjs sets .innerText on TEXTAREA elements instead of .value
    if (typeof(Ruby) != 'undefined') {
      if (input.tagName == 'TEXTAREA') {
        var value = input.innerText;
      } else {
        var value = input.value;
      }
    } else {
      var value = input.value;
    }
    present = present && value.length > 0;
  });

  if (present) {
    $('#letter_preview').html("<a href='/letters/preview' data-preview='true'>Preview letter</a>");
    $('a[data-preview]').click(previewLetter);
  } else {
    $('#letter_preview').html('');
  }
}

function previewLetter() {
  data = {}
  $.each($('.preview'), function(index, input) {
    data[input.getAttribute('name')] = input.value;
  })
  $('#letter_preview').html('<img src="/images/ajax-loader.gif" />');
  $.ajax({
    type: 'POST',
    url: '/letters/preview',
    data: data,
    success: function(data, status, xhr) {
      $('#letter_preview').html('<img src="/images/tmp/' + data + '"/>')
    }
  });
  return false;
}

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
