require 'lcdeploy/errors'

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
        Log.debug "Validating #{params} using #{param_spec}"
        param_spec.validate!(params)
      else
        Log.warning "No schema specified for #{self.class.name}"
      end
    end

    def run!
      raise NotImplementedError
    end

    def param_spec
      nil
    end

    def register!(ctx)
      ctx.register!(as_user(ctx.current_user))
    end

    # TODO: Better way to do this?
    def as_user(user)
      param_spec && param_spec.maybe_set_default!(:user, user)
      self
    end
  end

  module Steps
  end
end
