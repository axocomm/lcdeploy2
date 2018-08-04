require 'json'
require 'yaml'

module LCD
  class Context
    attr_reader :config

    def initialize
      @steps = []
      @config = {}
      @current_user = nil
    end

    def switch_user!(user)
      @current_user = user
    end

    def register!(step)
      # If switch_user has been called, set the default user for the
      # step.
      step.default_user = @current_user if step.supports_user? && @current_user
      @steps << step
    end

    def run!
      @steps.map do |step|
        Log.info "Running step #{step}"
        begin
          step.run!
        rescue StandardError => e
          raise StepRunFailed.new(step, e)
        end
      end
    end

    def configure!(params)
      @config = if params.include?(:from_yaml)
                  Context.load_yaml(params[:from_yaml])
                elsif params.include?(:from_json)
                  Context.load_json(params[:from_json])
                else
                  params
                end
    end

    def ssh_config
      @config[:ssh] || {}
    end

    def to_h
      {
        steps: @steps.map(&:to_h),
        config: @config
      }
    end

    def self.load_yaml(filename)
      File.open(filename) do |fh|
        YAML.safe_load(fh.read, symbolize_names: true)
      end
    end

    def self.load_json(filename)
      File.open(filename) do |fh|
        JSON.parse(fh.read, symbolize_names: true)
      end
    end
  end

  class StepRunFailed < StandardError
    attr_reader :step, :exception

    def initialize(step, exception, *args)
      super(*args)
      @step = step
      @exception = exception
    end

    def message
      "Step #{step} failed with #{e}"
    end
  end
end
