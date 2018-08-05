require 'lcdeploy/internal_dsl/errors'
require 'lcdeploy/internal_dsl/field_spec'

module LCD
  module InternalDSL
    class ParamSpec
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
        puts "Register #{field}:#{type} with #{options}"
        @fields[field] = FieldSpec.new(field, type, options)
      rescue FieldSpecError => e
        $stderr.puts(e)
        raise
      end

      def to_h
        Hash[@fields.map { |k, s| [k, s.to_h] }]
      end
    end
  end
end
