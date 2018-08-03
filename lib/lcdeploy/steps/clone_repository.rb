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

      def run!
        puts "Would clone_repository #{@repository}"
      end

      def to_h
        { repository: @repository }.merge(super.to_h)
      end
    end
  end
end
