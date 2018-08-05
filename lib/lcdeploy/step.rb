module LCD
  class Step
    def initialize(params = {})
      validate_params!(params)
      @params = params
    end

    def validate_params!
      param_schema && param_schema.validate!(params)
    end

    def run!
      raise NotImplementedError
    end

    def param_schema
      nil
    end

    def register!(ctx)
      ctx.register!(self)
    end
  end
end
