# Comply
Server-side ActiveRecord validations, all up in your client-side HTML.

## Intention and Purpose
Rendering the same page over and over due to validations is a slow and unpleasant user experience. The logical alternative is, of course, validating the form on the page, before it is submitted.

Though it's better, doing that still requires duplicating your validations on the client and server. Any time you change a validation in one place, it must be changed in the other as well. In addition, some validations require hitting the server and database, for example validating the uniqueness of an email address.

The solution offered here is combine the server-side validations with inline error messages on the form. This is done by creating an API for validating your objects. When triggered, the form is serialized and sent to the API endpoint, where it is instantiated as your ActiveRecord model, and validations are run. The API returns the instance's error messages, which the form uses to determine if the described object is valid.

## Basic Usage
Include Comply in your gemfile:
```ruby
gem 'comply'
```
If you are using Rails 3, you need to include `strong_parameters`
```ruby
gem 'comply'
gem 'strong_parameters'
```
Mount the engine in your `routes.rb`:
```ruby
mount Comply::Engine => '/comply'
```
Require the javascript files & dependencies in the form's corresponding javascript file (requires Asset Pipeline):
```js
//= require jquery
//= require comply
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
You can control the behavior of your validatable forms and inputs in a variety of ways.

### Validation route
You can specify the route to be used for validation on the form by setting the `data-validate-route` attribute.
```erb
<%= form_for @movie, html: { data: { validate_model: 'movie', validate_route: custom_validation_path } } do |f| %>
```

### Success messages
Want success messages to add some personality to your forms? Add the message as the `data-validate-success` attribute.
```erb
<%= f.text_field :title, data: { validate: true, validate_success: "Sweet title yo!" } %>
```

### Event triggers
You can change the jQuery event which triggers the input validation with the `data-validate-event` attribute.
```erb
<%= f.text_field :description, data: { validate: true, validate_event: 'click' } %>
```
Note: the default event is `input keyup`.

### Timeouts
You can delay validation by setting the `data-validate-timeout` attribute. This is great for things like checking a string's format so that it won't validate until the user has had a chance to finish typing.
```erb
<%= f.text_field :description, data: { validate: true, validate_timeout: 1000 } %>
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
Normally, a multiparameter input won't validate until all of its fields have been completed. If you want to override that, you can set the `data-validate-force` attribute. This is good if you don't want to represent your multiparameter fields as one unit.
```erb
<%= f.date_select :release_date, { order: [:month, :day] }, data: { validate: true, multiparam: 'release_date' } %>
<%= f.text_field :'release_date(1i)', id: 'release_date_1i', data: { validate: true, multiparam: 'release_date', validate_force: true } %>
```

## Customizing the ValidationMessage class
If you don't want to use the default `Comply.ValidationMessage`, which is responsible for putting the validation message tag on the page and handling the display of messages, great news: you can overwrite it!

After you've included Comply in the Asset Pipeline, feel free to extend it! For example (in `foo.js.coffee`):
```coffeescript
class Comply.ValidationMessage extends Comply.BaseValidationMessage
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

```ruby
# routes.rb
mount Comply::Engine => '/joanie_loves_chachi'
```
```javascript
//= require comply

Comply.enginePath = 'joanie_loves_chachi';
```

## Customizing Validation Behavior
You can override the validation behavior by inheriting from `Comply::ValidationsController`. This can be useful for cases like forms which update specific attributes of an instance.

For example, if you have a "change email" form, and you want to validate the email's uniqueness against the current user, you can override the `validation_instance` method on `Comply::ValidationsController`, set corresponding routes, and add the `data-validate-route` attribute to your form.
```ruby
# my_validations_controller.rb
class MyValidationsController < Comply::ValidationsController
  def validation_instance
    current_user.attributes = @fields
    current_user
  end
end

# routes.rb
match 'validations' => 'my_validations#show', only: :show, as: :my_validation
```
```erb
<%= form_for @movie, html: { data: { validate_model: 'movie', validate_route: my_validation_path } } do |f| %>
```
