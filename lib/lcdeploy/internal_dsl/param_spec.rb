require 'lcdeploy/internal_dsl/errors'
require 'lcdeploy/internal_dsl/field_spec'
require 'lcdeploy/logging'

module LCD
  module InternalDSL
    class ParamSpec
      include ModuleLogger

      def initialize(&block)
        @fields = {}
        instance_eval(&block)
      end

      def include?(field)
        @fields.include?(field)
      end

      def set_default!(field, val)
        field = @fields[field]
        raise FieldOptionError, "#{field} does not exist" unless field
        field.default = val
      end

      def maybe_set_default!(field, val)
        include?(field) && set_default!(field, val)
      end

      def method_missing(field, *args)
        add_field!(field, *args)
      end

      def validate!(params)
        @fields.each do |f, s|
          s.validate!(params.include?(f), params[f])
        end
      end

      def add_field!(field, type, options = {})
        logger.silly "Registering #{field}:#{type} with #{options}"
        @fields[field] = FieldSpec.new(field, type, options)
      rescue FieldSpecError => e
        $stderr.puts(e)
        raise
      end

      # Prepare passed parameters and merge defaults.
      #
      # TODO: This should also eventually perform any conversions,
      # etc. registered in the parameters block?
      def prepare(params)
        defaults.merge(params)
      end

      def defaults
        @fields.inject({}) do |acc, (f, s)|
          acc[f] = s.default if s.has_default?
          acc
        end
      end

      def to_h
        Hash[@fields.map { |k, s| [k, s.to_h] }]
      end
    end
  end
end
