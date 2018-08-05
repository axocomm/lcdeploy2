require 'lcdeploy/internal_dsl'

defstep :print_date do
  parameters do
    date_format :string, required: true
  end

  label_param :date_format

  run do
    puts 'running'
  end
end
