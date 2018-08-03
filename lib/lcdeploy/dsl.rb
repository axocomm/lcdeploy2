require 'lcdeploy/steps/clone_repository'
require 'lcdeploy/steps/run_command'

module LCD
  class DSL
    def initialize(ctx)
      @ctx = ctx
    end

    # Actions

    def clone_repository(source, params = {})
      Steps::CloneRepository.new(source, params).register!(@ctx)
    end

    def run_command(command, params = {})
      Steps::RunCommand.new(command, params).register!(@ctx)
    end

    def self.eval!(filename, ctx)
      new(ctx).instance_eval(File.read(filename))
    end
  end
end
