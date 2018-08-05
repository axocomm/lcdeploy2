require 'lcdeploy/logging'
require 'lcdeploy/step'
require 'lcdeploy/internal_dsl/errors'
require 'lcdeploy/internal_dsl/param_spec'

module LCD
  module InternalDSL
    class StepDef
      def initialize(name, &block)
        @name = name
        @class_name = name.to_s.split(/_/).collect(&:capitalize).join

        @label_param = nil
        @param_spec = nil
        @command = nil
        @run_block = nil

        instance_eval(&block)
      end

      # DSL methods

      def parameters(&block)
        @param_spec = ParamSpec.new(&block)
        puts "Spec is #{@param_spec}"
      end

      def label_param(name)
        @label_param = name.to_sym
      end

      def ssh_command(&block)
        @command = block
      end

      def run(&block)
        @run_block = block
      end

      # Class generation

      def classify!
        klass = LCD::Steps.const_set(@class_name, Class.new(LCD::Step))
        label_param = @label_param
        attrs = [label_param, :params]

        param_spec = @param_spec
        run_block = @run_block

        Log.warning "Registering #{@class_name} expecting #{attrs}"

        klass.class_eval do
          attr_accessor *attrs

          define_method(:initialize) do |label, params = {}|
            param_spec.validate!(params)
            instance_variable_set("@#{label_param}", label)
            instance_variable_set('@params', params)
          end

          define_method(:param_spec) { param_spec }

          define_method(:run!, run_block)
        end
      end

      def to_h
        {
          name: @name,
          class_name: @class_name,
          param_spec: @param_spec.to_h,
          ssh_command: @command,
          run_block: @run_block
        }
      end
    end
  end
end
