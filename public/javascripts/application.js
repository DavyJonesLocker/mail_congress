$(function() {
  $('#flash').delay(3000).slideUp(500);

  $('li#sign_in a').click(function() { 
    $(this).hide(); 
    $('.session form').fadeToggle();
    return false;
  });

  if ($('.session form').length > 0) {
    $('#sign_in_email').blur(function() { placeHolder($(this), 'Email'); });
    $('#sign_in_email').focus(function() { if (this.value == 'Email') {this.value = ''; $(this).removeClass('gray');} });
    placeHolder($('#sign_in_email'), 'Email');
    $('#sign_in_password').blur(function() { placeHolderPassword($(this), 'Password'); });
    $('#sign_in_password').focus(function() { if (this.value == 'Password') {this.value = ''; $(this).removeClass('gray'); this.type = 'password';} });
    placeHolderPassword($('#sign_in_password'), 'Password');
  }
});

function placeHolderPassword(input, text) {
  if (input.val() == '') {
    input[0].value = text;
    input[0].type  = 'text';
  } else if (input.val() == text) {
    input[0].type = 'text';
  } else { 
    input[0].type = 'password';
  }
  placeHolder(input, text);
}

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
