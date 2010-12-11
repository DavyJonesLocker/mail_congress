$(function() {
  $(':checked').each(function() { toggleListItem($(this).parent()[0]) });
  $('ul.legislators li').click(function() { toggleBioguide(this); });
  $('ul.legislators li input[type="checkbox"]').hide();
  $('.preview').keyup(showLetterPreview);
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

function toggleBioguide(listItem) {
  var check_box = $(listItem).find('[type="checkbox"]');
  if (check_box.attr('checked')) {
    check_box.attr('checked', false);
  } else {
    check_box.attr('checked', true);
  }
  toggleListItem(listItem);
  updateCost();
}

function toggleListItem(listItem) {
  listItem      = $(listItem);
  var bioguide  = listItem.find('.bioguide'),
      check_box = listItem.find('[type="checkbox"]'),
      mail      = listItem.find('img.mail');

  if (check_box.attr('checked')) {
    bioguide.removeClass('monochrome');
    listItem.addClass('active');
    bioguide.addClass('color');
    mail.fadeIn();
  } else {
    bioguide.removeClass('color');
    listItem.removeClass('active');
    bioguide.addClass('monochrome');
    mail.fadeOut();
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
