class window.BaseValidationMessage
  constructor: (@$el) ->
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
