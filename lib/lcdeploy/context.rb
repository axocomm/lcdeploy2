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

      logger.silly 'Creating a new StepRegistry'
      @step_registry = StepRegistry.new
      @step_registry.register_all!
    end

    def switch_user!(user)
      @current_user = user
    end

    def step?(name)
      @step_registry.include?(name)
    end

    # Initialize a new step by name with provided arguments.
    def new_step(name, *args)
      @step_registry[name].new(*args)
    end

    # Initialize a step and enqueue it, passing self to ensure access
    # to this context.
    def enqueue_step!(name, *args)
      new_step(name, *args).enqueue!(self)
    end

    def enqueue!(step)
      @steps << step
    end

    def run!
      @steps.inject(run: [], skipped: []) do |acc, step|
        logger.info "Running step #{step}"
        k, result = run_step!(step)
        acc[k] << result
      end
    end

    def run_step!(step)
      result = step.run!
      logger.info "Run result was #{result}"
      [:run, [step, result]]
    rescue StepSkipped => e
      reason = e.reason
      logger.info "Step skipped: #{reason}"
      [:skipped, [step, reason]]
    rescue StepFailed => e
      logger.error "Step #{step} failed with #{e.type}"
      raise
    rescue StandardError
      logger.error "An exception occurred running #{step}"
      raise
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
