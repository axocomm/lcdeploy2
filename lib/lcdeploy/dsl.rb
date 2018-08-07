require 'lcdeploy/logging'

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

    def method_missing(mtd, *args)
      if @ctx.step?(mtd)
        enqueue_step!(mtd, *args)
      else
        super
      end
    end

    def enqueue_step!(step_name, *args)
      @ctx.enqueue!(step_name, *args)
    end

    # Evaluation

    def self.eval!(filename, ctx)
      new(ctx).instance_eval(File.read(filename))
    end
  end
end
