$:.push File.expand_path('../lib', __FILE__)

require 'comply/version'

Gem::Specification.new do |s|
  s.name        = 'comply'
  s.version     = Comply::VERSION
  s.authors     = ['@jacobaweiss', '@andyjbas', '@azach', '@linedotstar', '@cfurrow']
  s.email       = ['jack@lumoslabs.com']
  s.homepage    = 'http://www.github.com/lumoslabs/comply'
  s.summary     = 'Inline validation of your ActiveRecord models via the AJAX internets'
  s.description = 'Validate your ActiveRecord models on the client, showing their error and success messages by providing a validation controller.'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'coffee-rails'
  s.add_dependency 'bartt-ssl_requirement', '~> 1.4.2'
  s.add_dependency 'rails', '~> 3.2.0'
  s.add_dependency 'strong_parameters', '~> 0.2.0'

  s.add_development_dependency 'pry-nav'
  s.add_development_dependency 'rspec-rails', '~> 3.2.0'
  s.add_development_dependency 'sqlite3'
end
