require 'lcdeploy/context'
require 'lcdeploy/dsl'

module LCD
  class Lcdfile
    def initialize(filename)
      @filename = filename
      @ctx = Context.new
    end

    def preview(params = {})
      eval!

      # TODO: Default should be a simpler printout like rupervisor
      case params[:format]
      when /json/
        puts @ctx.to_json
      when /yaml/
        puts @ctx.to_yaml
      else
        puts @ctx.to_h
      end
    end

    def run!
      eval!
      RunSucceeded.new @ctx.run!
    rescue StepFailed => e # TODO: Fix error handling
      Log.debug e
      raise if @ctx.debug
      RunFailed.new e
    rescue DSLEvalFailed => e
      Log.debug e
      raise if @ctx.debug
      RunFailed.new e
    end

    class RunResult
      attr_reader :success

      def initialize(success)
        @success = success
      end

      def to_h
        { success: @success }
      end
    end

    class RunFailed < RunResult
      attr_reader :error

      def initialize(error = nil)
        super(false)
        @error = error
      end

      def error_type
        @error.class
      end

      def exception?
        @error.is_a?(Exception)
      end

      def to_h
        super.to_h.merge error: @error, is_exception: exception?
      end
    end

    class RunSucceeded < RunResult
      attr_reader :step_results

      def initialize(step_results = [])
        super(true)
        @step_results = step_results
      end

      # TODO: There should be a flag indicating a step was skipped.
      def steps_run
        @step_results.count
      end

      def to_h
        super.to_h.merge steps: @step_results
      end
    end

    private

    def eval!
      DSL.eval!(@filename, @ctx)
    end
  end
end
