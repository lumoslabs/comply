begin
  require 'strong_parameters'
rescue LoadError
end

module Comply
  class ValidationsController < Comply::ApplicationController
    before_action :require_model, :require_fields

    if ActiveModel.const_defined?(:ForbiddenAttributesProtection)
      include ActiveModel::ForbiddenAttributesProtection
    end

    def show
      ActiveSupport::Deprecation.warn('GET support going away: use POST to access this endpoint') if request.request_method == 'GET'
      @instance = validation_instance
      @instance.valid?(validation_context)
      render json: { error: @instance.errors }
    end

    protected

    def validation_context
      :comply
    end

    private

    def validation_instance
      @model.new(post_params)
    end

    def post_params
      params.require(params[:model].to_sym).permit!
    end

    def require_fields
      @fields = params[params[:model].downcase]  if params[params[:model].downcase].present?
      render json: { error: 'Form fields not found' }, status: 500 unless @fields
    end

    def require_model
      @model = Comply::WhitelistConstantize.constantize(params[:model]) if params[:model].present?
    rescue NameError, Comply::WhitelistConstantize::NotWhitelistedError
      @model = nil
    ensure
      render json: { error: 'Model not found' }, status: 500 unless @model
    end
  end
end
