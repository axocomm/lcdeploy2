require 'lcdeploy/context'
require 'lcdeploy/dsl'

module LCD
  class Lcdfile
    def initialize(filename)
      @filename = filename
      @ctx = Context.new
    end

    def run!
      DSL.eval!(@filename, @ctx)
    end
  end
end
