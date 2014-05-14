module MagicWord
  class ValidationsController < MagicWord::ApplicationController
    before_filter :require_model, :require_fields

    def create
      instance = @model.new(post_params)
      instance.valid?
      render json: {error: instance.errors, success: instance.respond_to?(:valid_messages) ? instance.valid_messages : []}
    end

    private

    def require_model
      @model = params[:model].classify.constantize
    end

    def require_fields
      @fields = params[params[:model].downcase]
    end

    def post_params
      params.require(params[:model].to_sym).permit(*@fields.keys.map(&:to_sym))
    end
  end

end
