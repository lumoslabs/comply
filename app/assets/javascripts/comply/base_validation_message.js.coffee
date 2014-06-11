class Comply.BaseValidationMessage
  constructor: (@$el) ->
    if multiparam = @$el.data('multiparam')
      selector = "[data-multiparam=#{multiparam}].validation-msg"
      @$el.parent().append("<div data-multiparam='#{multiparam}' class='validation-msg'></div>") unless $(selector).length
      @$messageField = $(selector)
    else
      @$el.after("<div class='validation-msg'></div>")
      @$messageField = @$el.siblings('.validation-msg')

  successMessage: (message = '') ->
    @resetMessage message
    @$messageField.addClass 'success'

  errorMessage: (message = '') ->
    @resetMessage message
    @$messageField.addClass 'error'

  resetMessage: (message) ->
    @$messageField.html message
    @$messageField.removeClass 'error success'
