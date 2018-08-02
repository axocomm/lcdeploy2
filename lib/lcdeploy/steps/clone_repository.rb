require 'lcdeploy/step'

module LCD
  module Steps
    class CloneRepository < LCD::Step
      parameters do
        target :string, required: true
      end

      def initialize(repository, params = {})
        super(params)
        @repository = repository
      end
    end
  end
end
