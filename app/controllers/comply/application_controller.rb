module Comply
  class ApplicationController < ActionController::Base
    force_ssl if: :ssl_configured?

    private

    def ssl_configured?
      Rails.env.staging? || Rails.env.production?
    end
  end
end
