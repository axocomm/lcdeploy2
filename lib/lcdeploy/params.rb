module LCD
  class ParamSchema
    def initialize(&block)
      @fields = {}
      instance_eval(&block)
    end

    def method_missing(mtd, *args)
      @fields[mtd] = FieldSpec.new(*args)
    end

    def validate(doc)
      @fields.inject({}) do |acc, (field, spec)|
        exists = doc.include?(field)
        if (err = spec.validate(exists, doc[field]))
          acc[field] = err
        end

        acc
      end
    end

    def include?(key)
      @fields.include?(key)
    end

    def to_h
      @fields.inject({}) do |acc, (field, spec)|
        acc.merge(field => spec.to_h)
      end
    end

    class FieldSpec
      TYPES = %i[int float string symbol array] # For now

      attr_reader :type

      def initialize(type, params = {})
        raise FieldSpecError, "#{type} is invalid" \
          unless TYPES.include?(type)

        @type = type
        @required = params.delete(:required)

        extra_keys = params.keys
        raise FieldSpecError, "Extra keys #{extra_keys.join(', ')} found" \
          unless extra_keys.empty?
      end

      def validate(exists, val)
        return (@required ? :missing_required : nil) unless exists
        return :invalid_type unless valid_type?(val)
        nil
      end

      def to_h
        { type: @type, required: @required }
      end

      class FieldSpecError < StandardError
      end

      private

      def valid_type?(val)
        case @type
        when :int
          val.is_a?(Integer)
        when :float
          val.is_a?(Float)
        when :string
          val.is_a?(String)
        when :symbol
          val.is_a?(Symbol)
        when :array
          val.is_a?(Array)
        else
          # This should never happen
          false
        end
      end
    end
  end
end
