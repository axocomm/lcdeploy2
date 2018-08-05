require 'lcdeploy/internal_dsl/errors'

module LCD
  module InternalDSL
    class FieldSpec
      TYPE_CLASSES = {
        array: Array,
        hash: Hash,
        int: Integer,
        float: Float,
        string: String,
        symbol: Symbol
      }

      OPTIONS = {
        required: [TrueClass, FalseClass],
        choices: Array,
        default: :default
      }

      def initialize(name, type, options = {})
        FieldSpec.validate_self!(type, options)

        @name = name
        @type = type
        @options = options
        @type_validator = type_validator(@type)
      end

      def required?
        @options[:required]
      end

      def default
        @options[:default]
      end

      def validate!(exists, val)
        if required? && !exists
          raise FieldSpecError, "No value provided for #{@name}"
        elsif exists && !@type_validator.call(val)
          raise FieldSpecError, "#{val} is not a #{@type}"
        end
      end

      # Return a proc that checks the type of the value.
      #
      # This will be composed with any choice/custom validators
      # eventually.
      def type_validator(type)
        cls = TYPE_CLASSES[type]
        proc { |val| val.is_a?(cls) }
      end

      def to_h
        {
          type: @type,
          options: @options
        }
      end

      # Validate the options that were passed into this Field
      # definition. This includes checking the data type and the
      # options hash.
      #
      # If anything is wrong, an Exception is raised.
      def self.validate_self!(type, options)
        unless TYPE_CLASSES.include?(type)
          raise UnsupportedFieldType, "#{type} is an invalid field type"
        end

        val_valid = lambda do |opt, v|
          v_type = OPTIONS[opt]
          if v_type == :default
            v.is_a?(TYPE_CLASSES[type])
          elsif v_type.is_a?(Array)
            v_type.map { |t| v.is_a?(t) }.any?
          else
            v.is_a?(v_type)
          end
        end

        options.each do |opt, val|
          unless OPTIONS.include?(opt)
            raise FieldOptionError, "#{opt} is not a valid option"
          end

          unless val_valid[opt, val]
            raise FieldOptionError, "#{val} is not valid for #{opt}"
          end
        end
      end
    end
  end
end
