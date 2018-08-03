require 'lcdeploy/logging'
require 'lcdeploy/step'

module LCD
  module Steps
    class RenderTemplate < LCD::RemoteStep
      parameters do
        target :string, required: true
        user :string
        variables :hash
      end

      def initialize(local_file, params = {})
        super(params)
        @local_file = local_file
      end

      def variables
        @params[:variables]
      end

      def run!
        Log.debug "Would render #{@local_file} with #{variables}"
      end

      def to_h
        super.to_h.merge(local_file: @local_file)
      end
    end
  end
end
