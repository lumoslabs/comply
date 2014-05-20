class MagicWord.ValidatableInput
  constructor: (@$el, @form) ->
    parts          = @$el.attr('name').replace(/\]/g, '').split('[')
    @model         = _.first(parts)
    @attrName      = _.last(parts).split('(')[0]
    @event         = @$el.data('validate-event') or 'input keyup'
    @timeoutLength = @$el.data('validate-timeout') or 500
    @dependency    = @_dependency()
    @message       = new MagicWord.ValidationMessage @$el
    @$el.bind @event, @validate

  validate: =>
    if @_validatable()
      clearTimeout @timeout
      @timeout = setTimeout @_submitValidations, @timeoutLength

  setMessage: (status, message) ->
    @message["#{status}Message"] message

  #private

  _dependency: ->
    new MagicWord.ValidatableInput($("#{@$el.data('validate-with')}[name]"), @form) if @$el.data('validate-with')?

  _forceValidate: -> @forceValidate or= @$el.data('validate-force')

  _multiparam: -> @multiparam or= @$el.data('multiparam')

  _multiparamFields: ->
    _.without $("[data-multiparam=#{@_multiparam()}]"), _.first(@$el)

  _$multiparamFields: ->
    @$multiparamFields or= _.map @_multiparamFields(), (field) -> $(field)

  _submitValidations: => @form.validate inputs: _.compact [this, @dependency]

  _validatable: ->
    return true if @_forceValidate() or not @_multiparam()
    !_.detect @_$multiparamFields(), ($el) -> _.isEmpty $el.val()
