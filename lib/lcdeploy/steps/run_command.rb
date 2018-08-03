require 'lcdeploy/logging'
require 'lcdeploy/step'

module LCD
  module Steps
    class RunCommand < LCD::Step
      parameters do
        user :string
        cwd :string
      end

      def initialize(command, params = {})
        super(params)

        @command = command
      end

      def run!
        Log.debug "Would run #{@command}"
      end

      def user
        @params[:user]
      end

      def cwd
        @params[:cwd]
      end

      def to_h
        {
          command: @command,
          user: user,
          cwd: cwd
        }
      end
    end
  end
end
