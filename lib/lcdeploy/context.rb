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
  end
end
