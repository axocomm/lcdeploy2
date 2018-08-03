require 'lcdeploy/logging'
require 'lcdeploy/step'

module LCD
  module Steps
    class BuildDockerImage < LCD::Step
      parameters do
        cwd :string
        tag :string
        dockerfile :string
      end

      def initialize(name, params = {})
        super(params)

        @name = name
      end

      def run!
        Log.debug "Would build docker image #{@name}"
      end

      def tag
        @params[:tag]
      end

      def dockerfile
        @params[:dockerfile]
      end

      def to_h
        {
          image_name: @name,
          tag: tag,
          dockerfile: dockerfile
        }
      end
    end
  end
end
