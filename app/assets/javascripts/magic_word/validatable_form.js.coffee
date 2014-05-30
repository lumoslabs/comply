class MagicWord.ValidatableForm
  constructor: (@$form) ->
    @inputs          = @_inputs()
    @model           = @$form.data('validate-model')
    @$button         = @$form.find('[type=submit]')
    @validationRoute = "/#{MagicWord.enginePath}/validations"
    @$button.click @validateInputs
    @$button.attr('disabled', false).removeClass('disabled')

  validateInputs: (event) =>
    event.preventDefault()
    @validate inputs: @inputs, submit: true

  validate: (options) ->
    $.get @validationRoute, @_params(), (response) =>
      return @$form.submit() if options.submit && @_allSuccess(response)
      @_setMessages(options.inputs, response)

  # private

  _setMessages: (inputs, response) =>
    for input in inputs
      status = @_isSuccess(input, response)
      input.setMessage status, @_responseValue(input, response, status)

  _allSuccess: (response) -> !Object.keys(response.error).length

  _inputs: ->
    for input in @$form.find('[data-validate][name]')
      new MagicWord.ValidatableInput $(input), this

  _isSuccess: (input, response) ->
    if !!@_responseValue(input, response) then 'error' else 'success'

  _params: -> "#{$.param(model: @model)}&#{@$form.serialize()}"

  _responseValue: (input, response, status = 'error') ->
    if response[status]? then response[status][input.attrName]
