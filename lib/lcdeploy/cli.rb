require 'thor'

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
      puts "Yo it's #{filename}"
    end

    desc 'deploy LCDFILE', 'Deploy from an lcdfile'
    def deploy(filename = 'Lcdfile')
      puts "Deploying from #{filename}"
    end

    private

    def configure_logging!
      if options[:verbose]
        puts 'verbose'
      elsif options[:quiet]
        puts 'quiet'
      end
    end
  end
end
