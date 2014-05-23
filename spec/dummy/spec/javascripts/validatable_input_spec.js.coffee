#= require magic_word

describe 'ValidatableInput', ->
  beforeEach ->
    @input          = $('<input name="foo[bar]"/>')
    @form           = validate: ->
    @defaultTimeout = 500
    @v = new MagicWord.ValidatableInput @input, @form

  describe "#constructor", ->
    it 'sets the default timeout to 500ms', ->
      expect(@v.timeoutLength).toBe(@defaultTimeout)

    it 'sets default bind event', ->
      expect(@v.event).toBe("input keyup")

    describe "when timeout is set on the input", ->
      beforeEach ->
        @input = $("<input data-validate-timeout='666' name='foo[bar]' value='' />")
        @v = new MagicWord.ValidatableInput @input, @form

      it 'uses the timeout provided', ->
        expect(@v.timeoutLength).toBe(666)

    describe "when an alternate event is provided", ->
      beforeEach ->
        @input = $("<input data-validate-event='input keydown' name='foo[bar]' />")
        @v = new MagicWord.ValidatableInput @input, @form

      it 'uses the event provided', ->
        expect(@v.event).toBe("input keydown")

  describe "#validate", ->
    it 'sets the timer', ->
      expect(@v.timeout).toBeUndefined()
      @v.validate()
      expect(@v.timeout).not.toBeUndefined()

    it 'submits the form to the timeout', ->
      spyOn(window, 'setTimeout')
      @v.validate()
      expect(window.setTimeout).toHaveBeenCalledWith(@v._submitValidations, @defaultTimeout)

    it 'calls submitValidations after timeout expires', (done)->
      spyOn(@v,'_submitValidations')
      @v.validate()
      setTimeout =>
        expect(@v._submitValidations).toHaveBeenCalled()
        done()
      , @defaultTimeout

    it 'calls form.validate', (done)->
      spyOn(@v.form, 'validate')
      @v.validate()
      setTimeout =>
        expect(@v.form.validate).toHaveBeenCalled()
        done()
      , @defaultTimeout

    it 'does not call validate if the input is empty', ->
      fail()

    it 'validates another input if passed to validate-with', ->
      fail()

    it 'can validate multiple fields at the same time', ->
      fail()
