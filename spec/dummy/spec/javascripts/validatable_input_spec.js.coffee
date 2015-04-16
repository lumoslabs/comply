#= require comply

describe 'ValidatableInput', ->
  beforeEach ->
    @defaultTimeoutLength = 500
    @form = validate: ->
    @inputjQuery = $("<input name='foo[bar]'/>")
    @input = new Comply.ValidatableInput @inputjQuery, @form

  describe '#constructor', ->
    it 'sets the default timeout length to 500ms', ->
      expect(@input.timeoutLength).toBe(@defaultTimeoutLength)

    it 'sets the default event to bind', ->
      expect(@input.event).toBe('input keyup')

    describe 'when timeout length is set on the input', ->
      beforeEach ->
        @inputjQuery = $("<input data-validate-timeout='666' name='foo[bar]' value='' />")
        @input = new Comply.ValidatableInput @inputjQuery, @form

      it 'uses the timeout length provided', ->
        expect(@input.timeoutLength).toBe(666)

    describe "when an alternate event is provided", ->
      beforeEach ->
        @inputjQuery = $("<input data-validate-event='input keydown' name='foo[bar]' />")
        @input = new Comply.ValidatableInput @inputjQuery, @form

      it 'uses the event provided', ->
        expect(@input.event).toBe("input keydown")

  describe '#validate', ->
    it 'sets the timer', ->
      expect(@input.timeout).toBeUndefined()
      @input.validate()
      expect(@input.timeout).not.toBeUndefined()

    it 'submits the form to the timeout', ->
      spyOn(window, 'setTimeout')
      @input.validate()
      expect(window.setTimeout).toHaveBeenCalledWith(@input._submitValidations, @defaultTimeoutLength)

    it 'calls submitValidations after timeout expires', (done)->
      spyOn(@input, '_submitValidations')
      @input.validate()
      setTimeout =>
        expect(@input._submitValidations).toHaveBeenCalled()
        done()
      , @defaultTimeoutLength

    it 'calls form.validate', (done)->
      spyOn(@input.form, 'validate')
      @input.validate()
      setTimeout =>
        expect(@input.form.validate).toHaveBeenCalled()
        done()
      , @defaultTimeoutLength

    describe 'with a dependency', ->
      beforeEach ->
        @input.dependency = new Comply.ValidatableInput $("<input name='foo[baz]'/>"), @form
        spyOn(@input.form, 'validate')

      it 'validates another input if passed to validate-with', (done) ->
        @input.validate()
        setTimeout =>
          expect(@input.form.validate).toHaveBeenCalledWith(inputs: [@input, @input.dependency])
          done()
        , @defaultTimeoutLength

  describe '#_validatable', ->
    describe 'with forceValidate set', ->
      beforeEach ->
        @inputjQuery = $("<input data-validate-force='true' name='foo[bar]'/>")
        @input = new Comply.ValidatableInput @inputjQuery, @form

      it 'is validatable', ->
        expect(@input._validatable()).toBe(true)

    describe 'when not a multiparameter input', ->
      beforeEach ->
        @inputjQuery = $("<input name='foo[bar]'/>")
        @input = new Comply.ValidatableInput @inputjQuery, @form

      it 'is true if forceValidate is set', ->
        expect(@input._validatable()).toBe(true)
