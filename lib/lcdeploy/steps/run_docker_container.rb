require 'lcdeploy/logging'
require 'lcdeploy/step'

module LCD
  module Steps
    class RunDockerContainer < LCD::Step
      parameters do
        image :string, required: true
        tag :string
        volumes :array # TODO: Validate inside arrays
        ports :array
      end

      def initialize(name, params = {})
        super(params)
        @name = name
      end

      def image
        @params[:image]
      end

      def tag
        @params[:tag]
      end

      def volumes
        @params[:volumes]
      end

      def ports
        @params[:ports]
      end

      def run!
        Log.debug "Would run container #{@name}"
      end

      def to_h
        {
          container_name: @name,
          image: image,
          tag: tag,
          volumes: volumes,
          ports: ports
        }
      end
    end
  end
end
