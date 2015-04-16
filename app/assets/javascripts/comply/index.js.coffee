#= require comply/config
#= require_tree .

$ ->
  $('[data-validate-model]').each ->
    $(this).data('comply-form', new Comply.ValidatableForm($(this)))
