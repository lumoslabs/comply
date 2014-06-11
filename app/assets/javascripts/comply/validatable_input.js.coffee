class Comply.ValidatableInput
  constructor: (@$el, @form) ->
    parts          = @$el.attr('name').replace(/\]/g, '').split('[')
    @model         = parts[0]
    @attrName      = parts[parts.length - 1].split('(')[0]
    @event         = @$el.data('validate-event') or 'input keyup'
    @timeoutLength = @$el.data('validate-timeout') or 500
    @successMessage = @$el.data('validate-success')
    @dependency    = @_dependency()
    @message       = new Comply.ValidationMessage @$el
    @$el.bind @event, @validate

  validate: =>
    if @_validatable()
      clearTimeout @timeout
      @timeout = setTimeout @_submitValidations, @timeoutLength

  setMessage: (status, message) ->
    message = @successMessage if status is 'success'
    @message["#{status}Message"] message

  #private

  _dependency: ->
    new Comply.ValidatableInput($("#{@$el.data('validate-with')}[name]"), @form) if @$el.data('validate-with')?

  _forceValidate: -> @forceValidate or= @$el.data('validate-force')

  _multiparam: -> @multiparam or= @$el.data('multiparam')

  _multiparamFields: ->
    field for field in $("[data-multiparam=#{@_multiparam()}]") when field isnt @$el[0]

  _$multiparamFields: ->
    @$multiparamFields or= $(field) for field in @_multiparamFields()

  _submitValidations: => @form.validate inputs: (el for el in [this, @dependency] when el)

  _validatable: ->
    return true if @_forceValidate() or not @_multiparam()
    !($el for $el in @_$multiparamFields() when !$el.val().length).length
