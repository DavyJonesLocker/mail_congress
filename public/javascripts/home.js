$(function() {
  var address = (new Address).random();
  $('#address').blur(function() { placeHolder($(this), address) });
  $('#address').focus(function() { if (this.value == address) {this.value = ''; $(this).removeClass('gray');} });
  placeHolder($('#address'), address);
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

var Address = function() {
  var data = [
    '1640 Riverside Drive Hill Valley, CA'
  ];
  this.random = function() {
    var randomIndex = Math.ceil(Math.random()*data.length) - 1;
    return data[randomIndex];
  }
  this.includes = function(address) {
    for (var i = 0; i < data.length; i++) {
      if (address == data[i]) {
        return true;
      }
    }
    return false;
  }
}
