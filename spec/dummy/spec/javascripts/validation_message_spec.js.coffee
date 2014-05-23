#= require magic_word

describe 'ValidationMessage', ->
  beforeEach ->
    @messageBox = $('<div>Stuff</div>')
    @m = new MagicWord.ValidationMessage @messageBox

  describe '#constructor', ->
    it 'creates a validation message div', ->
      expect(@messageBox.siblings('.validation-msg').length).toBe(1)

  describe '#successMessage', ->
    it "sets the validation message's class to success", ->
      @m.successMessage()
      expect(@messageBox.siblings('.validation-msg').attr('class')).toBe('validation-msg success')

  describe '#errorMessage', ->
    it "sets the validation message's class to error", ->
      @m.errorMessage()
      expect(@messageBox.siblings('.validation-msg').attr('class')).toBe('validation-msg error')

  describe '#resetMessage', ->
    it 'sets the given message', ->
      @m.resetMessage('Your validation passed!')
      expect(@messageBox.siblings('.validation-msg').text()).toBe('Your validation passed!')
