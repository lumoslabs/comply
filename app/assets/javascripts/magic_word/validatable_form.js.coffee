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
    $.post @validationRoute, @_params(), (response) =>
      return @$form.submit() if options.submit && @_allSuccess(response)
      _.each options.inputs, (input) =>
        status = @_isSuccess(input, response)
        input.setMessage status, @_responseValue(input, response, status)

  # private

  _allSuccess: (response) -> !_.detect response.error, (e) -> e.length

  _inputs: ->
    _.map @$form.find('[data-validate][name]'), (input) =>
      new MagicWord.ValidatableInput $(input), this

  _isSuccess: (input, response) ->
    if !!@_responseValue(input, response) then 'error' else 'success'

  _params: -> "#{$.param(model: @model)}&#{@$form.serialize()}"

  _responseValue: (input, response, status = 'error') ->
    msg = response[status][input.attrName]
    if typeof msg is 'object' then _.last msg else msg
