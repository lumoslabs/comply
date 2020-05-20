# 2.0.0
* Dropped support for rails3 (use 1.9.0 for older rails versions).
* Handled rails5+ deprecations.

# 1.9.0 (formerly 1.8.1)
* Support both POST and GET at the `/validations` endpoint
* Deprecate support for GET at the `/validations` endpoint

# 1.8.0
* Allow a Comply controller to define a custom validation context, instead of the default `:comply`.

# 1.7.0
* Pass custom context `:comply` to validations (the former context used to default to `:create`)

# 1.6.0
* Move Rails 4 & 3 compatibility to Gemfile rather than gemspec

# 1.5.2
* Add support for options requests

# 1.5.1
* Add fix for rails 4 where activemodel/validations directory does not work

# 1.5.0
* Rails 4.0.13 compatibility
