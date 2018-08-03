require 'lcdeploy/logging'
require 'lcdeploy/step'

module LCD
  module Steps
    class CloneRepository < LCD::RemoteStep
      parameters do
        target :string, required: true
      end

      def initialize(repository, params = {})
        super(params)
        @repository = repository
      end

      def run!
        Log.debug "Would clone repository #{@repository}"
      end

      def to_h
        { repository: @repository }.merge(super.to_h)
      end
    end
  end
end
