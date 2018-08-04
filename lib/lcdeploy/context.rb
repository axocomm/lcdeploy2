require 'json'
require 'yaml'

module LCD
  class Context
    attr_reader :config, :debug

    def initialize
      @steps = []
      @config = {}
      @current_user = nil
      @debug = true # TODO: Pass debug from CLI
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
      @steps.inject(run: [], skipped: []) do |acc, step|
        Log.info "Running step #{step}"
        begin
          acc[:run] << [step, step.run!]
        rescue StepSkipped => e
          acc[:skipped] << [step, e.reason]
        rescue StepFailed => e
          Log.error "Step #{step} failed with #{e.type}"
          raise
        rescue StandardError
          Log.error "An exception occurred running #{step}"
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
end
