require 'colorize'

module LCD
  module Logging
    class Logger
      LEVELS = {
        silly: ['~~>', :blue],
        debug: ['==>', :white],
        info: ['===', :green],
        warning: ['===', :yellow],
        error: ['!!!', :red]
      }

      attr_reader :level

      def initialize(name, level = :debug)
        @name = name
        @level = level
      end

      def configure!(params = {})
        @level = params[:level] if params.include?(:level)
      end

      def enabled?(level)
        Logger.enabled_levels_at(@level).include?(level)
      end

      LEVELS.keys.each do |level|
        define_method(level) { |msg| log msg, level }
      end

      def log(msg, level = :info)
        if enabled?(level)
          prefix, color = LEVELS[level]
          puts "#{prefix} #{line(msg)}".colorize(color: color, mode: :bold)
        end
      end

      def line(msg)
        "[#{@name}] #{msg}"
      end

      def self.enabled_levels_at(level)
        idx = LEVELS.keys.index(level) || 0
        LEVELS.keys[idx..-1]
      end
    end

    class RootLogger < Logger
      def initialize
        super(:root)
      end

      def line(msg)
        msg
      end
    end

    class LoggerManager
      @@loggers = { root: RootLogger.new }
      @@config = { level: :debug }

      def self.level
        @@config[:level]
      end

      def self.logger(name)
        @@loggers[name] || (@@loggers[name] = Logger.new(name, level))
      end

      def self.root_logger
        logger(:root)
      end

      def self.configure!(params = {})
        @@config = @@config.merge(params)

        loggers = [root_logger]
        loggers += @@loggers.values if params[:all]
        loggers.each { |logger| logger.configure!(params) }
      end
    end

    class <<self
      Logger::LEVELS.keys.each do |level|
        define_method(level) { |msg| log msg, level }
      end

      def log(msg, level)
        LoggerManager.root_logger.log(msg, level)
      end

      def configure!(params)
        LoggerManager.configure!(params.merge(all: true))
      end

      def logger(name)
        LoggerManager.logger(name)
      end

      def [](name)
        logger(name)
      end
    end

    def self.levels
      Logger::LEVELS.keys
    end
  end

  module ModuleLogger
    def logger
      label = File.basename(caller_locations(1, 1)[0].path, '.rb')
      Logging::LoggerManager.logger(label)
    end
  end
end
