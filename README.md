# MagicWord
Server-side ActiveRecord validations, all up in your client-side HTML.

## Basic Usage
Include Magic Word in your gemfile:
```ruby
gem 'magic_word'
```
Mount the engine in your `routes.rb`:
```ruby
mount MagicWord::Engine => '/magic_word'
```
Require the javascript files & dependencies in the form's corresponding javascript file (requires Asset Pipeline):
```js
//= require jquery
//= require lodash
//= require magic_word
```

In your form:
Add the `data-validate-model` tag to your form tag with the name of the model you intend to validate:
```erb
<%= form_for @movie, html: { data: { validate_model: 'movie' } } do |f| %>
```
On the input tags you want validated, add the `data-validate` tag:
```erb
<div class="field">
  <%= f.label :title %><br>
  <%= f.text_field :title, data: { validate: true } %>
</div>
<div class="field">
  <%= f.label :description %><br>
  <%= f.text_area :description, data: { validate: true } %>
</div>
```

Of course, this all assumes you have ActiveRecord validations set up in your model:
```ruby
class Movie < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  validates :desciption, presence: true
end
```

## Customizations
You can control the behavior of your validatable inputs in a variety of ways.

### Success messages
Want success messages to add some personality to your forms? Add the message as the `data-validate-success` attribute.
```erb
<div class="field">
  <%= f.text_field :title, data: { validate: true, validate_success: "Sweet title yo!" } %>
</div>
```

### Event triggers
You can change the jQuery event which triggers the input validation with the `data-validate-event` attribute.
```erb
<div class="field">
  <%= f.text_field :description, data: { validate: true, validate_event: 'click' } %>
</div>
```
Note: the default event is `input keyup`.

### Timeouts
You can delay the triggering of an input's validation by setting the `data-validate-timeout` attribute. This is great for things like checking a string's format so that it won't trigger until the user has had a chance to finish typing.
```erb
<div class="field">
  <%= f.text_field :description, data: { validate: true, validate_timeout: 1000 } %>
</div>
```
Note: the amount is in milliseconds, and the default amount is 500 milliseconds.

### Validation dependencies
Sometimes you have two fields that you want to validate at the same time. You can ensure they will be serialized and validated together using the `data-validate-with` attribute, which takes the jQuery selector of the dependent object. This can be useful for things like confirmation fields.
```erb
<%= f.label :password %>
<%= f.password_field :password, class: "span6" %>

<%= f.label :password_confirmation %>
<%= f.password_field :password_confirmation, data: { validate: true, validate_with: '#user_password' } %>
```

### Multiparameter attributes
Want to validate multiple fields as one like a multiparameter attribute? Add the `data-multiparam` attribute to your inputs. This is great for multivalue fields like dates.
```erb
<%= f.date_select :release_date, {}, data: { validate: true, multiparam: 'release_date' } %>
```

#### Forcing validations on multiparameters
Normally, a multiparameter input won't trigger until all of its fields have been completed. If you want to override that, you can set the `data-validate-force` attribute.
```erb
<%= f.date_select :release_date, {}, data: { validate: true, multiparam: 'release_date', validate_force: true } %>
```

## Customizing the ValidationMessage class
If you don't want to use the default `MagicWord.ValidationMessage`, which is responsible for putting the validation message tag on the page and handling the display of messages, great news: you can overwrite it!

After you've included MagicWord in the Asset Pipeline, feel free to extend it! For example (in `foo.js.coffee`):
```coffeescript
class MagicWord.ValidationMessage extends MagicWord.BaseValidationMessage
  constructor: (@$el) ->
    super
    console.log 'We can build him. We have the technology.'

  successMessage: (message = '') ->
    super
    console.log 'All systems go.'

  errorMessage: (message = '') ->
    super
    console.log 'Houston, we have a problem.'

  resetMessage: (message) ->
    super
    console.log 'Mulligan!'
```

## Mounting the engine elsewhere
If you would like to mount the engine under a different namespace, all you need to do is add the engine path to the javascript object:
Routes file:
```ruby
mount MagicWord::Engine => '/joanie_loves_chachi'
```
Javascript file:
```javascript
//= require magic_word

MagicWord.enginePath = 'joanie_loves_chachi';
```

## Intenion and Purpose
Rendering the same page over and over due to validations is a slow and unpleasant user experience. The logical alternative is, of course, validating the form on the page, before it is submitted.

Though it's better, doing that still requires duplicating your validations on the client and server. Any time you change a validation in one place, it must be changed in the other as well. In addition, some validations require hitting the server and database, for example validating the uniqueness of an email address.

The solution offered here is combine the server-side validations with inline error messages on the form. This is done by creating an API for validating your objects. When triggered, the form is serialized and sent to the API endpoint, where it is instantiated as your ActiveRecord model, and validations are run. The API returns the instance's error messages, which the form uses to determine if the described object is valid.
