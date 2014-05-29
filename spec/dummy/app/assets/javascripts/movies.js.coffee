# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

#= require jquery
#= require lodash
#= require magic_word

class MagicWord.ValidationMessage extends MagicWord.BaseValidationMessage
  constructor: (@$el) ->
    if multiparam = @$el.data('multiparam')
      $field = $("[data-multiparam=#{multiparam}].validation-msg")

      # if message field doesn't exist, create it
      # else, use the existing one
      if $field.length == 0
        @$el.parent('.field').append("<div data-multiparam='#{multiparam}' class='validation-msg'></div>")
        @$messageField = $("[data-multiparam=#{multiparam}].validation-msg")
      else
        @$messageField = $field
    else
      super


