require 'lcdeploy/logging'
require 'lcdeploy/steps/clone_repository'
require 'lcdeploy/steps/create_directory'
require 'lcdeploy/steps/run_command'

module LCD
  class DSL
    def initialize(ctx)
      @ctx = ctx
    end

    # Context actions

    def configure(params)
      @ctx.configure!(params)
    end

    def config
      @ctx.config
    end

    def log(message, level = :info)
      Log.log("[lcdfile] #{message}", level)
    end

    def switch_user!(user)
      Log.info "Switching to user #{user}"
    end

    # Step registration

    def clone_repository(source, params = {})
      Steps::CloneRepository.new(source, params).register!(@ctx)
    end

    def run_command(command, params = {})
      Steps::RunCommand.new(command, params).register!(@ctx)
    end

    def create_directory(path, params = {})
      Steps::CreateDirectory.new(path, params).register!(@ctx)
    end

    # Evaluation

    def self.eval!(filename, ctx)
      new(ctx).instance_eval(File.read(filename))
    end
  end
end
