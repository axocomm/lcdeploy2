# require 'lcdeploy/logging'
# require 'lcdeploy/step'

# module LCD
#   module Steps
#     class PrintDate < LCD::RemoteStep
#       parameters {}

#       def initialize(date_format = nil)
#         super()
#         @date_format = date_format
#       end

#       def run!
#         cmd = 'date'
#         cmd += " +'#{@date_format}'" unless @date_format.nil?
#         ssh_exec cmd
#       end

#       def to_h
#         { date_format: @date_format }
#       end
#     end
#   end
# end

require 'lcdeploy/internal_dsl'

defstep :print_date do
  parameters {}

  label_param :date_format

  run do
    puts 'running'
  end
end
