require 'lcdeploy/context'
require 'lcdeploy/dsl'

module LCD
  class Lcdfile
    def initialize(filename)
      @filename = filename
      @ctx = Context.new
    end

    def preview
      eval!
      puts @ctx.to_h
    end

    def run!
      eval!
      @ctx.run!
    rescue StepRunFailed => e # TODO: Fix error handling
      Log.debug e
      Log.error e.message
    rescue DSLEvalFailed => e
      Log.debug e
      Log.error e.message
    end

    private

    def eval!
      DSL.eval!(@filename, @ctx)
    end
  end
end
