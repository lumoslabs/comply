ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../spec/dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'pry-nav'

if Rails::VERSION::STRING < '5.0.0'
  module Shop
    module ActionControllerTestCaseRails5Shim
      def process(action, http_method = 'GET', *args)
        # Rails 5 prints a deprecation warning for parameters passed in the options hash
        # for get/post/etc. Instead you're supposed to pass them via params:, eg:
        #
        # Rails 4: get :action, id: 1
        # Rails 5: get :action, params: { id: 1 }
        #
        # Under Rails 4, this small monkeypatch is designed to extract the params: hash
        # and merge it with the rest of the options passed to get/post/etc. That way
        # we'll be able to support Rails 4 and 5 concurrently.
        #
        # Finally, Rails 5 changed the way XHR requests are made:
        #
        # Rails 4: xhr :post, :create, id: 1
        # Rails 5: post :create, xhr: true, params: { id: 1 }
        #
        # Accordingly, this monkeypatch converts Rails 5-compatible XHR calls into
        # Rails 4-compatible ones by invoking the xhr method and passing the http
        # method and action as positional arguments.
        #

        if params = args.find { |arg| arg.is_a?(Hash) }
          if params.include?(:params)
            params.merge!(params.delete(:params))
          end

          if params[:xhr]
            params.delete(:xhr)
            return xhr(http_method.downcase, action, params)
          end
        end

        super
      end
    end
  end

  ActionController::TestCase::Behavior.prepend(
    Shop::ActionControllerTestCaseRails5Shim
  )
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
