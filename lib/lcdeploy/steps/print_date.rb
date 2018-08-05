require 'lcdeploy/internal_dsl'

defstep :print_date do
  parameters {}

  label_param :date_format

  run do
    puts 'running'
  end
end
