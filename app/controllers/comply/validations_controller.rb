begin
  require 'strong_parameters'
rescue LoadError
end

module Comply
  class ValidationsController < Comply::ApplicationController
    before_filter :require_model, :require_fields

    if ActiveModel.const_defined?(:ForbiddenAttributesProtection)
      include ActiveModel::ForbiddenAttributesProtection
    end

    def show
      @instance = validation_instance
      @instance.valid?(:comply)
      render json: { error: @instance.errors }
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
