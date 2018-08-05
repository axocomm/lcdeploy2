module LCD
  class StepFailed < StandardError
    attr_reader :step, :error

    def initialize(step, details, *args)
      super(*args)
      @step = step
      @details = details
    end

    def type
      if @details.include?(:ssh_result)
        :ssh_command_failed
      elsif @details.include?(:exception)
        :exception
      else
        :other
      end
    end

    def dump
      case type
      when :ssh_command_failed
        dump_ssh_result
      when :exception
        $stderr.puts e
      when :other
        $stderr.puts @details
      end
    end

    def dump_ssh_result
      result = @details[:ssh_result]
      $stderr.puts <<EOT
stdout
------
#{result.stdout}

stderr
------
#{result.stderr}
EOT
    end
  end

  class StepSkipped < StandardError
    attr_reader :step, :reason

    def initialize(step, reason, *args)
      super(*args)
      @step = step
      @reason = reason
    end

    def message
      "Step #{step} skipped: #{@reason}"
    end
  end
end
