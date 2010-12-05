$(function() {
  $('input[placeholder], textarea[placeholder]').placeholder();
  $('label.placeheld').hide();
  $('.alert, .notice').delay(3000).slideUp(500);

  $('li#sign_in a').click(function() { 
    $(this).hide(); 
    $('.session form').fadeToggle();
    return false;
  });
});

