module LCD
  class Context
    def initialize
      @steps = []
    end

    def register!(step)
      @steps << step
    end

    def run!
      puts "Would run #{@steps.map(&:to_h).inspect}"
    end

    def to_h
      { steps: @steps.map(&:to_h) }
    end
  end
end
