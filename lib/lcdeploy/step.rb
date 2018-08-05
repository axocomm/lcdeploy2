require 'lcdeploy/errors'

module LCD
  class Step
    def initialize(params = {})
      validate_params!(params)
      @params = params
    end

    def validate_params!(params)
      param_schema && param_schema.validate!(params)
    end

    def run!
      raise NotImplementedError
    end

    def param_schema
      nil
    end

    def register!(ctx)
      ctx.register!(as_user(ctx.current_user))
    end

    # TODO: Better way to do this?
    def as_user(user)
      param_schema && param_schema.maybe_set_default!(user: user)
      self
    end
  end

  module Steps
  end
end
