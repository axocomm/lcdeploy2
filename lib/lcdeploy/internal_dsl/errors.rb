module LCD
  module InternalDSL
    class StepDefError < StandardError
    end

    class StepAttributeInvalid < StepDefError
    end

    class ParamSpecError < StepDefError
    end

    class FieldSpecError < ParamSpecError
    end

    class UnsupportedFieldType < FieldSpecError
    end

    class FieldOptionError < FieldSpecError
    end
  end
end
