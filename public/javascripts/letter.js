$(function() {
  $('ul.legislators li').click(function() { toggleLegislator(this); });
  $('ul.legislators li input[type="checkbox"]').hide();
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
      if (input.value == 'First name' || input.value == 'Last name') {
        var value = '';
      } else {
        if (input.tagName == 'TEXTAREA') {
          var value = $('.campaign .body').text() || input.value;
          if (value == 'Please write your letter here.') {
            value = '';
          }
        } else {
          var value = input.value;
        }
      }
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
  });

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

function toggleLegislator(listItem) {
  toggleBioguide(listItem);
  updateCost();
}

function toggleBioguide(listItem) {
  listItem     = $(listItem);
  var bioguide = listItem.find('.bioguide'),
      id       = listItem.find('[type="checkbox"]'),
      mail     = listItem.find('img.mail');

  if (id.attr('checked')) {
    bioguide.removeClass('color');
    listItem.removeClass('active');
    bioguide.addClass('monochrome');
    id.attr('checked', false);
    mail.fadeOut();
  } else {
    bioguide.removeClass('monochrome');
    listItem.addClass('active');
    bioguide.addClass('color');
    id.attr('checked', true);
    mail.fadeIn();
  }
}

function updateCost() {
  var total      = 0;
  var costHeader = $('h2.cost');
  $('ul.legislators input[type="checkbox"]').each(function() {
    if (this.checked) {
     total += 1;
    }
  });
  switch(total) {
    case 0:
      var costHTML = "Please choose to whom you wish to write";
      costHeader.removeClass('money');
      break;
    
    case 1:
      var costHTML = "$1 to send this letter";
      costHeader.addClass('money');
      break;
    
    default:
      var costHTML = "$" + total + " to send these letters";
      costHeader.addClass('money');
      break;
  }
  costHeader.text(costHTML);
}
