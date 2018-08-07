require 'rubygems'

module LCD
  GEM_NAME = 'lcdeploy'

  module Helpers
    def this_gem
      Gem.loaded_specs[LCD::GEM_NAME]
    end
  end
end
