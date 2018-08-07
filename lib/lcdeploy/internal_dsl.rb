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
        step = LCD::InternalDSL::StepDef.new(name, &block)
        logger.info "Created #{step}"
        step.classify!
      end

      def self.eval!(filename, registry)
        new(registry).instance_eval(File.read(filename))
      end
    end
  end
end
