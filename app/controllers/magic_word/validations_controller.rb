module MagicWord
  class ValidationsController < MagicWord::ApplicationController
    before_filter :require_model, :require_fields

    def show
      instance = @model.new(post_params)
      instance.valid?
      render json: {error: instance.errors, success: instance.respond_to?(:valid_messages) ? instance.valid_messages : []}
    end

    private

    def post_params
      params.require(params[:model].to_sym).permit!
    end

    def require_fields
      @fields = params[params[:model].downcase]  if params[params[:model].downcase].present?
      render json: { error: 'Form fields not found' }, status: 500 unless @fields
    end

    def require_model
      @model = params[:model].classify.constantize if params[:model].present?
      render json: { error: 'Model not found' }, status: 500 unless @model
    end
  end
end
