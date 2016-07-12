source "https://rubygems.org"

# Declare your gem's dependencies in comply.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'rails', ENV['RAILS_VERSION'] || '~> 4.0.13'

if ENV['RAILS_VERSION'] && ENV['RAILS_VERSION'] >= '4'
  gem 'protected_attributes'
else
  gem 'strong_parameters', '~> 0.2.0'
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
