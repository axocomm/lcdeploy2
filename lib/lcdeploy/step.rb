require 'lcdeploy/params'

module LCD
  class Step
    @@param_schema = nil

    def initialize(params = {})
      err = validate_params(params)
      raise BadParams, err unless err.empty?

      @params = params
    end

    def run!
      raise NotImplementedError
    end

    def register!(ctx)
      ctx.register!(self)
    end

    def self.parameters(&block)
      @@param_schema = ParamSchema.new(&block)
    end

    def validate_params(params)
      @@param_schema && @@param_schema.validate(params)
    end

    def to_h
      @params
    end

    def to_s
      str = to_h.map { |(k, v)| [k.to_s, v].join('=') }.join(',')
      "#{self.class.name.split(/::/).last}[#{str}]"
    end

    class BadParams < StandardError
    end
  end
end
