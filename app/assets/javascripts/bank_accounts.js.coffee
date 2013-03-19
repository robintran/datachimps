$ ->
  $('#new_bank_account').on 'submit', (e)->
    validation = balanced.bankAccount.validate({
      bank_code: $('#bank_account_routing_number').val(),
      account_number: $('#bank_account_account_number').val(),
      name: $('#bank_account_name').val()
      })
    unless $.isEmptyObject(validation)
      e.preventDefault()
      for k, v of validation
        alert(v + '!')
        break
