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
        @run_block = nil

        @remote_step = false

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

      def remote_step!
        @remote_step = true
      end

      def run(&block)
        @run_block = block
      end

      # Class generation

      def superclass
        if @remote_step
          LCD::RemoteStep
        else
          LCD::Step
        end
      end

      def classify!
        step_type = @name
        klass = LCD::Steps.const_set(@class_name, Class.new(superclass))
        label_param = @label_param
        attrs = [label_param, :params]

        param_spec = @param_spec
        run_block = @run_block

        Log.debug "Registering #{@class_name} expecting #{attrs}"

        klass.class_eval do
          attr_reader *attrs

          define_method(:initialize) do |label, params = {}|
            Log.info "Creates a new #{klass}"
            super(params.merge(label_param => label))

            @params.each do |p, v|
              instance_variable_set("@#{p}", v)
            end
          end

          define_method(:param_spec) { param_spec }
          define_method(:run!, run_block)
          define_method(:step_type) { step_type }
        end

        klass
      end

      def to_h
        {
          name: @name,
          class_name: @class_name,
          param_spec: @param_spec.to_h,
          run_block: @run_block
        }
      end
    end
  end
end
