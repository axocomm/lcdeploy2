require 'lcdeploy/params'
require 'lcdeploy/ssh'

module LCD
  class Step
    def initialize(params = {})
      err = validate_params(params)
      raise BadParams, err unless err.empty?

      @params = params
    end

    def run!
      raise NotImplementedError
    end

    def register!(ctx)
      ctx.register!(self)
    end

    def supports_user?
      param_schema && param_schema.include?(:user)
    end

    def default_user=(user)
      @params[:user] = user unless @params[:user]
    end

    def self.parameters(&block)
      schema = ParamSchema.new(&block)
      class_eval { define_method(:param_schema) { schema } }
    end

    def validate_params(params)
      param_schema && param_schema.validate(params)
    end

    def to_h
      @params
    end

    def to_s
      str = to_h.map { |(k, v)| [k.to_s, v].join('=') }.join(',')
      "#{self.class.name.split(/::/).last}[#{str}]"
    end

    class BadParams < StandardError
    end
  end

  class RemoteStep < Step
    SSH_DEFAULTS = {
      user: ENV['USER'],
      port: 22
    }

    def register!(ctx)
      super
      @ssh_config = ctx.ssh_config
    end

    def ssh_config
      SSH_DEFAULTS.merge(@ssh_config)
    end

    def ssh_exec(cmd)
      LCD::SSH.ssh_exec(cmd, ssh_config)
    end
  end
end
