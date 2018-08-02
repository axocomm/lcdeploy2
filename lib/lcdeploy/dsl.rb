require 'lcdeploy/steps/clone_repository'

module LCD
  class DSL
    def initialize(ctx)
      @ctx = ctx
    end

    # Actions

    def clone_repository(source, params = {})
      Steps::CloneRepository.new(source, params).register!(@ctx)
    end

    def self.eval!(filename, ctx)
      new(ctx).instance_eval(File.read(filename))
    end
  end
end
