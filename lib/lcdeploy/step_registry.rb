require 'rubygems'

require 'lcdeploy/errors'
require 'lcdeploy/helpers'
require 'lcdeploy/internal_dsl'
require 'lcdeploy/logging'
require 'lcdeploy/step'

module LCD
  class StepRegistry
    include Helpers
    include ModuleLogger

    attr_reader :step_types

    def initialize
      @step_types = {}
    end

    def include?(name)
      @step_types.include?(name)
    end

    def [](name)
      @step_types[name]
    end

    def register_all!
      glob = "#{step_dir}/*.rb"
      logger.info "Loading steps from #{glob}"
      Dir.glob(glob).each { |file| register_step!(file) }
    end

    def register_step!(filename)
      puts 'fuck'
      logger.info "Registering step(s) from #{filename}"

      name, klass = InternalDSL::StepsDSL.eval!(filename, self)
      add!(name, klass)
    end

    def add!(name, klass)
      logger.info "Registering #{name}"
      @step_types[name] = klass
    end

    def step_dir
      File.join(this_gem.lib_dirs_glob, this_gem.name, 'steps')
    end
  end
end
