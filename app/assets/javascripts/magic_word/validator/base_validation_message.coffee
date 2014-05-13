class window.BaseValidationMessage
  constructor: (@$el) ->
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
