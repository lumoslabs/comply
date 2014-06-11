module Comply
  class ApplicationController < ActionController::Base
    include ::SslRequirement
  end
end
