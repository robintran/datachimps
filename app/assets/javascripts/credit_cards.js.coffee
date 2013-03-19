$ ->
  $('#new_credit_card').on 'submit', (e)->
    validation = balanced.card.validate({
      card_number: $('#credit_card_card_number').val(),
      expiration_month: $('#credit_card_expiration_month').val(),
      expiration_year: $('#credit_card_expiration_year').val(),
      security_code: $('#credit_card_security_code').val()
    })
    unless $.isEmptyObject(validation)
      e.preventDefault()
      for k, v of validation
        alert(v + '!')
        break
