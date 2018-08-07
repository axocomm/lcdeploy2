require 'thor'

require 'lcdeploy/lcdfile'
require 'lcdeploy/logging'

module LCD
  class CLI < Thor
    include LCD
    include ModuleLogger

    class_option :silly, type: :boolean, aliases: :s
    class_option :debug, type: :boolean, aliases: :d
    class_option :quiet, type: :boolean, aliases: :q

    def initialize(*args)
      super
      configure_logging!
    end

    desc 'preview LCDFILE', 'Preview deploy steps'
    option :format, aliases: :f
    def preview(filename = 'Lcdfile')
      Lcdfile.new(filename).preview(format: options[:format])
    end

    desc 'deploy LCDFILE', 'Deploy from an lcdfile'
    def deploy(filename = 'Lcdfile')
      logger.info "Deploying from #{filename}"
      result = Lcdfile.new(filename).run!
      puts result.to_h
    end

    private

    def configure_logging!
      level = if options[:silly]
                :silly
              elsif options[:debug]
                :debug
              elsif options[:quiet]
                :warning
              else
                :info
              end
      Logging.configure! level: level
    end
  end
end
