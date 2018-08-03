require 'json'
require 'yaml'

module LCD
  class Context
    def initialize
      @steps = []
      @config = {}
    end

    def register!(step)
      @steps << step
    end

    def run!
      puts "Would run #{@steps.map(&:to_h).inspect}"
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
