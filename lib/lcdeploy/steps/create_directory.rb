require 'lcdeploy/step'

module LCD
  module Steps
    class CreateDirectory < LCD::Step
      parameters do
        user :string
        group :string
        mode :symbol
      end

      def initialize(path, params = {})
        super(params)
        @path = path
      end

      def run!
        puts "Would create directory #{@path}"
      end

      def to_h
        { path: @path }.merge(super.to_h)
      end
    end
  end
end
