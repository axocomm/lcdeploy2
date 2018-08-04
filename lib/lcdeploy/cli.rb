require 'thor'

require 'lcdeploy/lcdfile'
require 'lcdeploy/logging'

module LCD
  class CLI < Thor
    include LCD

    class_option :verbose, type: :boolean, aliases: :v
    class_option :quiet, type: :boolean, aliases: :q

    def initialize(*args)
      super
      configure_logging!
    end

    desc 'preview LCDFILE', 'Preview deploy steps'
    def preview(filename = 'Lcdfile')
      Lcdfile.new(filename).preview
    end

    desc 'deploy LCDFILE', 'Deploy from an lcdfile'
    def deploy(filename = 'Lcdfile')
      Log.info "Deploying from #{filename}"
      result = Lcdfile.new(filename).run!
      puts result.to_h
    end

    private

    def configure_logging!
      if options[:verbose]
        Log.configure! verbose: true
      elsif options[:quiet]
        Log.configure! quiet: true
      end
    end
  end
end
