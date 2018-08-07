require 'lcdeploy/internal_dsl/step_def'
require 'lcdeploy/logging'

module LCD
  module InternalDSL
    class StepsDSL
      include ModuleLogger

      def initialize(registry)
        @registry = registry
      end

      # DSL Methods

      def defstep(name, &block)
        logger.silly "Defining new step #{name}"
        LCD::InternalDSL::StepDef.new(name, &block).classify!
      end

      def self.eval!(filename, registry)
        new(registry).instance_eval(File.read(filename))
      end
    end
  end
end
