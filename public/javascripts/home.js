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
    '1640 Riverside Drive Hill Valley, CA',
    '742 Evergreen Terrace Springfield, IM',
    '344 Washington St. Boston, MA',
    '185 West 74th Street, New York, NY',
    '711 Calhoun Street, Chicago, IL',
    '1060 West Addison Street, Chicago, IL',
    '4222 Clinton Way, Los Angeles, CA',
    '9764 Jeopardy Lane, Chicago, IL',
    '1000 Mammon Lane, Springfield, IM',
    '112 1/2 Beacon Street, Boston, MA',
    '420 Paper St. Wilmington, DE',
    '31 Spooner Street, Quahog, RI',
    '11435 18th Avenue, Oahu, HI',
    '2630 Hegal Place, Apt. 42, Alexandria, VA',
    '129 West 81st Street Apt 5E New York, NY',
    '88 Edgemont, Palisades, CA',
    '633 Stag Trail Road North Caldwell, NJ',
    '1630 Revello Drive, Sunnydale, CA',
    '111 Archer Avenue, New York City, NY'
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
