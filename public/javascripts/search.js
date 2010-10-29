$(function() {
  //$('form#address_search').submit(clientSideGeocoder);
});

function clientSideGeocoder() {
  var geocoder = new google.maps.Geocoder;
  geocoder.geocode({address: $('form#address_search input#address').val()}, function(results, status) {
    if (typeof(results[0]) != "undefined") {
      var address = results[0].address_components;
      switch(results[0].types[0]) {
        case "subpremise":
          var geoloc = {
            'street': [nameByType(address, 'street_number'), nameByType(address, 'route'), 'Apt ' + nameByType(address, 'subpremise')].join(' '),
            'city': nameByType(address, 'locality'),
            'state': nameByType(address, 'administrative_area_level_1'),
            'zip': nameByType(address, 'postal_code'),
            'lat': results[0].geometry.location.b,
            'lng': results[0].geometry.location.c
          }
          break;

        case "street_address":
          var geoloc = {
            'street': [nameByType(address, 'street_number'), nameByType(address, 'route')].join(' '),
            'city': nameByType(address, 'locality'),
            'state': nameByType(address, 'administrative_area_level_1'),
            'zip': nameByType(address, 'postal_code'),
            'lat': results[0].geometry.location.b,
            'lng': results[0].geometry.location.c
          }
          break;

        default:
          alert('Not a valid address.');
          return;
      }
      var csrf_token     = $('meta[name=csrf-token]').attr('content'),
          csrf_param     = $('meta[name=csrf-param]').attr('content'),
          form           = $('<form method="post" action="/search"></form>'),
          metadata_input = "";
      $.each(geoloc, function(name, value) {
        metadata_input += '<input name="geoloc['+name+']" value="'+value+'" type="hidden" />';
      });
      if (csrf_param != null && csrf_token != null) {
        metadata_input += '<input name="'+csrf_param+'" value="'+csrf_token+'" type="hidden" />';
      }
      form.hide()
          .append(metadata_input)
          .appendTo('body');
      form.submit();

    } else {
      alert('Not a valid address.');
    }
  });
  return false;
}

function nameByType(collection, type) {
  return $.grep(collection, function(obj) { return obj.types[0] == type; } )[0].short_name;
}

