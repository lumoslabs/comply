require 'strong_parameters'

module Comply
  class ValidationsController < Comply::ApplicationController
    ssl_allowed :show

    before_filter :require_model, :require_fields

    include ActiveModel::ForbiddenAttributesProtection

    def show
      @instance = validation_instance
      @instance.valid?
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
      @model = params[:model].classify.constantize if params[:model].present?
    rescue NameError
      @model = nil
    ensure
      render json: { error: 'Model not found' }, status: 500 unless @model
    end
  end
end
