 #= require magic_word

describe 'ValidatableForm', ->
  beforeEach ->
    @model = 'movie'
    @value = 'Gymkata'
    @input = "<input data-validate='true' name='movie[title]' value='#{@value}' type='text'>"
    @$form = $("<form data-validate-model='#{@model}'>#{@input}</form>")
    @v = new MagicWord.ValidatableForm @$form

  describe '#constructor', ->
    it 'sets the model to validate', ->
      expect(@v.model).toBe(@model)

    it 'sets the default validation path', ->
      expect(@v.validationRoute).toBe('/magic_word/validations')

    describe 'when MagicWord.enginePath has been set', ->
      beforeEach ->
        MagicWord.enginePath = 'wally_world'
        @v = new MagicWord.ValidatableForm @$form

      it 'sets the given validation path', ->
        expect(@v.validationRoute).toBe('/wally_world/validations')

  describe '#_inputs', ->
    it 'creates a new ValidatableInput for each input', ->
      expect(@v._inputs().length).toBe(1)

  describe '#_params', ->
    it 'serializes the form parameters', ->
      expect(@v._params()).toBe("model=#{@model}&movie%5Btitle%5D=#{@value}")

  describe '#_allSuccess', ->
    describe 'when all inputs are valid', ->
      beforeEach ->
        @response = { error: {} }

      it 'returns true', ->
        expect(@v._allSuccess(@response)).toBe(true)

    describe 'when there are invalid inputs', ->
      beforeEach ->
        @response = { error: { 'title': ["can't be blank"] } }

      it 'returns false', ->
        expect(@v._allSuccess(@response)).toBe(false)

  describe '#_isSuccess', ->
    beforeEach ->
      @vInput = _.first @v._inputs()

    describe 'when input is invalid', ->
      beforeEach ->
        @response = { error: { 'title': ["can't be blank"] } }

      it 'returns success', ->
        expect(@v._isSuccess(@vInput, @response)).toBe('error')

    describe 'when input is valid', ->
      beforeEach ->
        @response = { error: {}, success: [] }

      it 'returns success', ->
        expect(@v._isSuccess(@vInput, @response)).toBe('success')

  describe '#_setMessages', ->
    beforeEach ->
      @vInput = _.first @v._inputs()
      spyOn @vInput.message, 'resetMessage'
      @v._setMessages [@vInput], { error: {}, success: [] }

    it 'sets the message on ValidationMessage', ->
      expect(@vInput.message.resetMessage).toHaveBeenCalled()
