$(function() {
  $('ul.legislators li').click(function() { toggleLegislator(this); });
  $('.preview').keyup(showLetterPreview);
  updateCost();
  showLetterPreview();
  $('#letter_sender_attributes_first_name').blur(function() { placeHolder($(this), 'First name'); });
  $('#letter_sender_attributes_first_name').focus(function() { if (this.value == 'First name') {this.value = ''; $(this).removeClass('gray');} });
  placeHolder($('#letter_sender_attributes_first_name'), 'First name');
  $('#letter_sender_attributes_last_name').blur(function() { placeHolder($(this), 'Last name'); });
  $('#letter_sender_attributes_last_name').focus(function() { if (this.value == 'Last name') {this.value = ''; $(this).removeClass('gray');} });
  placeHolder($('#letter_sender_attributes_last_name'), 'Last name');
});

function placeHolder(input, text) {
  if (input.val() == '') {
    input[0].value = text;
    input.addClass('gray');
  } else if (input.val() == text) {
    input.addClass('gray');
  } else { 
    input.removeClass('gray');
  }
}

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
        var value = input.value;
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

function toggleLegislator(listItem) {
  toggleBioguide(listItem);
  updateCost();
}

function toggleBioguide(listItem) {
  listItem     = $(listItem);
  var bioguide = listItem.find('.bioguide'),
      id       = listItem.find('.legislator_id'),
      mail     = listItem.find('img.mail');

  if (id.attr('disabled')) {
    bioguide.removeClass('monochrome');
    listItem.addClass('active');
    bioguide.addClass('color');
    id.attr('disabled', null);
    mail.fadeIn();
  } else {
    bioguide.removeClass('color');
    listItem.removeClass('active');
    bioguide.addClass('monochrome');
    id.attr('disabled', 'disabled');
    mail.fadeOut();
  }
}

function updateCost() {
  var total      = 0;
  var costHeader = $('h2.cost');
  $('ul.legislators .legislator_id').each(function() {
    if (!this.disabled) {
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
