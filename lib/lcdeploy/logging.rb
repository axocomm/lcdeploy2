require 'colorize'

module LCD
  class Log
    LEVELS = {
      debug: ['***', :green],
      info: ['===', :white],
      warning: ['-->', :yellow],
      error: ['!!!', :red]
    }

    @@enabled = %i[info warning error]

    LEVELS.keys.each do |level|
      define_singleton_method(level) { |msg| log msg, level }
    end

    def self.configure!(params = {})
      if params[:verbose]
        @@enabled = %i[debug info warning error]
      elsif params[:quiet]
        @@enabled = %i[warning error]
      end
    end

    def self.log(message, level = :info)
      if @@enabled.include?(level)
        prefix, color = LEVELS[level]
        puts "#{prefix} #{message}".colorize(color: color, mode: :bold)
      end
    end
  end
end
