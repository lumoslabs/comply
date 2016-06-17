module Comply
  class ApplicationController < ActionController::Base
<<<<<<< Updated upstream
    force_ssl
=======
    force_ssl if: :ssl_configured?

    private

    def ssl_configured?
      Rails.env.staging? || Rails.env.production?
    end
>>>>>>> Stashed changes
  end
end
