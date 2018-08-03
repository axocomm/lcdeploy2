require 'lcdeploy/logging'
require 'lcdeploy/step'

module LCD
  module Steps
    class CreateDirectory < LCD::RemoteStep
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
        Log.debug "Would create directory #{@path}"
      end

      def to_h
        { path: @path }.merge(super.to_h)
      end
    end
  end
end
