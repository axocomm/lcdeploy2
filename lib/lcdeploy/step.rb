require 'lcdeploy/params'

module LCD
  class Step
    @param_schema = nil

    def self.parameters(&block)
      @param_schema = ParamSchema.new(&block)
    end
  end
end
