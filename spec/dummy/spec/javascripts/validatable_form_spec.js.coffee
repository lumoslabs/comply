 #= require magic_word

describe 'ValidatableForm', ->
  beforeEach ->
    @model = 'movie'
    @value = 'Gymkata'
    input = "<input data-validate='true' name='movie[title]' value='#{@value}' type='text'>"
    @formjQuery = $("<form data-validate-model='#{@model}'>#{input}</form>")
    @form = new MagicWord.ValidatableForm @formjQuery

  describe '#constructor', ->
    it 'sets the model to validate', ->
      expect(@form.model).toBe(@model)

    it 'sets the default validation path', ->
      expect(@form.validationRoute).toBe('/magic_word/validations')

    describe 'when MagicWord.enginePath has been set', ->
      beforeEach ->
        MagicWord.enginePath = 'wally_world'
        @form = new MagicWord.ValidatableForm @formjQuery

      it 'sets the given validation path', ->
        expect(@form.validationRoute).toBe('/wally_world/validations')

  describe '#_inputs', ->
    it 'creates a new ValidatableInput for each input', ->
      expect(@form._inputs().length).toBe(1)

  describe '#_params', ->
    it 'serializes the form parameters', ->
      expect(@form._params()).toBe("model=#{@model}&movie%5Btitle%5D=#{@value}")

  describe '#_allSuccess', ->
    describe 'when all inputs are valid', ->
      beforeEach ->
        @response = { error: {} }

      it 'returns true', ->
        expect(@form._allSuccess(@response)).toBe(true)

    describe 'when there are invalid inputs', ->
      beforeEach ->
        @response = { error: { 'title': ["can't be blank"] } }

      it 'returns false', ->
        expect(@form._allSuccess(@response)).toBe(false)

  describe '#_isSuccess', ->
    beforeEach ->
      @input = @form._inputs()[0]

    describe 'when input is invalid', ->
      beforeEach ->
        @response = { error: { 'title': ["can't be blank"] } }

      it 'returns success', ->
        expect(@form._isSuccess(@input, @response)).toBe('error')

    describe 'when input is valid', ->
      beforeEach ->
        @response = { error: {} }

      it 'returns success', ->
        expect(@form._isSuccess(@input, @response)).toBe('success')

  describe '#_setMessages', ->
    beforeEach ->
      @input = @form._inputs()[0]
      spyOn @input.message, 'resetMessage'
      @form._setMessages [@input], { error: {} }

    it 'sets the message on ValidationMessage', ->
      expect(@input.message.resetMessage).toHaveBeenCalled()
