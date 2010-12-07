$(function() {
  $('#payment_credit_card_number').keyup(function() { determineCardType(this.value) });
  $('form').submit(function(){$('input[type=submit]', this).attr('disabled', 'disabled');});
  determineCardType($('#payment_credit_card_number').val());
  $('input[name="letter[payment_type]"]').change(function() { toggleSlider(this); })
  if ($('input[name="letter[payment_type]"]:checked').val() == 'paypal') {
    choosePaypal(true);
  } else {
    chooseCreditCard();
  }
});

function choosePaypal(pageload) {
  $('div.help div.credit_card').hide();
  $('div.help div.paypal').show();
  if (pageload) {
    $('.slideToggle').hide();
  } else {
    $('.slideToggle').slideUp();
  }
  $('#payment_submit').attr('value', 'Pay with Paypal');
}

function chooseCreditCard() {
  $('div.help div.paypal').hide();
  $('div.help div.credit_card').show();
  $('.slideToggle').slideDown();
  $('#payment_submit').attr('value', 'Make secure payment');
}

function toggleSlider(input) {
  if (input.value == 'paypal') {
    choosePaypal(false);
  } else {
    chooseCreditCard();
  }
}

function determineCardType(number) {
  if (number == "") {
    $('.card').removeClass('disabled');
    return;
  }

  var creditCard = new CreditCard;
  var unMatchedCards = creditCard.unMatchedCards(number);
  $.each(unMatchedCards, function(index, type){
    $('.' + type).addClass('disabled');
  });
}

var CreditCard = function() {
  // RegExp stolen from GitHub. Sorry guys!
  this.matchers = {
                'visa': /^4/,
              'master': /^5[1-5]/,
            'discover': /^6011/,
    'american_express': /^3(4|7)/,
         'diners_club': /^(30[0-5]|36|38)/
  }

  this.findMatches = function(number) {
    var matchedCards = [];
    for (card in this.matchers) {
      if (this.matchers[card].test(number)) {
        matchedCards.push(card);
      }
    }
    return matchedCards;
  }

  this.unMatchedCards = function(number) {
    var matchedCards = this.findMatches(number);
    var unMatchedCards = [];
    if (matchedCards.length == 0) {
      return unMatchedCards;
    }
    for (type in this.matchers) {
      debugger
      if (!(new RegExp(matchedCards.join('|'))).test(type)) {
        unMatchedCards.push(type);
      }
    }
    return unMatchedCards;
  }
}
