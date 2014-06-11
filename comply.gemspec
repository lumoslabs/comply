$:.push File.expand_path('../lib', __FILE__)

require 'comply/version'

Gem::Specification.new do |s|
  s.name        = 'comply'
  s.version     = Comply::VERSION
  s.authors     = ['@jacobaweiss', '@andyjbas', '@azach']
  s.email       = ['jack@lumoslabs.com']
  s.homepage    = 'http://www.github.com/lumoslabs/comply'
  s.summary     = 'Inline validation of your ActiveRecord models via the AJAX internets'
  s.description = 'Validate your ActiveRecord models on the client, showing their error and success messages by providing a validation controller.'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'coffee-rails'
  s.add_dependency 'bartt-ssl_requirement', '~> 1.4.2'
  s.add_dependency 'rails'

  s.add_development_dependency 'jasmine-rails'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec-rails', '~> 2.14'
  s.add_development_dependency 'sqlite3'
end
