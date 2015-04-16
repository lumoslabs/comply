class Comply.BaseValidatableForm
  constructor: (@$form) ->
    return if @$form.data('complied')
    @$form.data('complied', true)
    @inputs          = @_inputs()
    @model           = @$form.data('validate-model')
    @$button         = @$form.find('[type=submit]')
    @validationRoute = @$form.data('validate-route') or "/#{Comply.enginePath}/validations"
    @$button.click @validateInputs
    @$button.attr('disabled', false).removeClass('disabled')

  validateInputs: (event) =>
    event.preventDefault()
    @validate inputs: @inputs, submit: true

  validate: (options) ->
    $.get @validationRoute, @_params(), (response) =>
      @_onValidate(response)

      if @_allSuccess(response)
        if @_onValidationSuccess(response)
          return @$form.submit() if options.submit
      else
        @_onValidationFailure(response)

      if @_onValidationComplete(response)
        @_setMessages(options.inputs, response)

  # private

  _onValidate: (response) ->
  _onValidationSuccess: (response) -> true
  _onValidationFailure: (response) -> true
  _onValidationComplete: (response) -> true

  _setMessages: (inputs, response) =>
    for input in inputs
      status = @_isSuccess(input, response)
      input.setMessage status, @_responseValue(input, response, status)

  _allSuccess: (response) -> not (err for field, err of response.error when err.length).length

  _inputs: ->
    for input in @$form.find('[data-validate][name]')
      new Comply.ValidatableInput $(input), this

  _isSuccess: (input, response) ->
    if !!@_responseValue(input, response) then 'error' else 'success'

  _params: -> "#{$.param(model: @model)}&#{@$form.serialize()}"

  _responseValue: (input, response, status = 'error') ->
    if response[status]? then response[status][input.attrName]
