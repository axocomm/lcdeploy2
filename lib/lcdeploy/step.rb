require 'lcdeploy/errors'
require 'lcdeploy/ssh'

module LCD
  class Step
    def initialize(params = {})
      if param_spec
        validate_params!(params)
        @params = param_spec.prepare(params)
      end
    end

    def validate_params!(params)
      if param_spec
        Logging.debug "Validating #{params} using #{param_spec}"
        param_spec.validate!(params)
      else
        Logging.warning "No schema specified for #{self.class.name}"
      end
    end

    def run!
      raise NotImplementedError
    end

    def param_spec
      nil
    end

    def enqueue!(ctx)
      ctx.enqueue!(as_user(ctx.current_user))
    end

    # TODO: Better way to do this?
    def as_user(user)
      param_spec && param_spec.maybe_set_default!(:user, user)
      self
    end

    def step_type
      nil
    end

    def to_h
      {
        type: step_type,
        params: @params
      }
    end
  end

  class RemoteStep < Step
    SSH_DEFAULTS = {
      user: ENV['USER'],
      port: 22
    }

    def enqueue!(ctx)
      super
      @ssh_config = SSH_DEFAULTS.merge(ctx.ssh_config)
    end

    def ssh_exec(cmd)
      result = LCD::SSH.ssh_exec(cmd, @ssh_config)
      unless result.success?
        Logging.error "SSH command #{cmd} failed with #{result.exit_code}"
        raise StepFailed.new(self, ssh_result: result)
      end
    end

    # TODO: Should probably not need to have this
    def to_h
      super.merge(remote: true)
    end
  end

  module Steps
  end
end
