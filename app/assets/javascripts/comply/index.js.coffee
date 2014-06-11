#= require comply/config
#= require_tree .

$ -> $('[data-validate-model]').each -> new Comply.ValidatableForm $(this)
