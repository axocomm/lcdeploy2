require 'lcdeploy/logging'
# require 'lcdeploy/steps/build_docker_image'
# require 'lcdeploy/steps/clone_repository'
# require 'lcdeploy/steps/create_directory'
require 'lcdeploy/steps/print_date'
# require 'lcdeploy/steps/render_template'
require 'lcdeploy/steps/run_command'
# require 'lcdeploy/steps/run_docker_container'

module LCD
  class DSL
    include ModuleLogger

    def initialize(ctx)
      @ctx = ctx
      logger.debug('Initializing a new DSL')
    end

    # Context actions

    def configure(params)
      @ctx.configure!(params)
    end

    def config
      @ctx.config
    end

    def log(message, level = :info)
      Logging[:lcdfile].log(message, level)
    end

    def switch_user(user)
      logger.info "Switching to user #{user}" unless user.nil?
      @ctx.switch_user! user
    end

    # Step registration

    # def build_docker_image(name, params = {})
    #   Steps::BuildDockerImage.new(name, params).register!(@ctx)
    # end

    # def run_docker_container(name, params = {})
    #   Steps::RunDockerContainer.new(name, params).register!(@ctx)
    # end

    # def clone_repository(source, params = {})
    #   Steps::CloneRepository.new(source, params).register!(@ctx)
    # end

    def run_command(command, params = {})
      Steps::RunCommand.new(command, params).register!(@ctx)
    end

    # def create_directory(path, params = {})
    #   Steps::CreateDirectory.new(path, params).register!(@ctx)
    # end

    # def render_template(local_file, params = {})
    #   Steps::RenderTemplate.new(local_file, params).register!(@ctx)
    # end

    def print_date(date_format = nil)
      Steps::PrintDate.new(date_format).register!(@ctx)
    end

    # Evaluation

    def self.eval!(filename, ctx)
      new(ctx).instance_eval(File.read(filename))
    end
  end
end
