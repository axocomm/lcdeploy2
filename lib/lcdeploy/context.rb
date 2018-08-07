require 'json'
require 'yaml'

require 'lcdeploy/logging'
require 'lcdeploy/step_registry'

module LCD
  class Context
    include ModuleLogger

    attr_reader :config, :debug, :current_user

    def initialize
      @steps = []
      @config = {}
      @current_user = nil
      @debug = true # TODO: Pass debug from CLI

      logger.info 'Creating a new StepRegistry'
      @step_registry = StepRegistry.new
      @step_registry.register_all!
    end

    def step?(name)
      @step_registry.include?(name)
    end

    def switch_user!(user)
      @current_user = user
    end

    def enqueue!(step_name, *args)
      cls = @step_registry[step_name]
      @steps << cls.new(*args)
    end

    def run!
      @steps.inject(run: [], skipped: []) do |acc, step|
        # TODO: Use ModuleLogger
        Logging.info "Running step #{step}"
        begin
          acc[:run] << [step, step.run!]
        rescue StepSkipped => e
          acc[:skipped] << [step, e.reason]
        rescue StepFailed => e
          Logging.error "Step #{step} failed with #{e.type}"
          raise
        rescue StandardError
          Logging.error "An exception occurred running #{step}"
          raise
        end

        acc
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
        config: @config,
        debug: @debug
      }
    end

    def to_json
      to_h.to_json
    end

    def to_yaml
      JSON.parse(to_json).to_yaml
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
end
