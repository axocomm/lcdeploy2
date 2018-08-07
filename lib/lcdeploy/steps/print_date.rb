defstep :print_date do
  parameters do
    date_format :string, required: true
  end

  label_param :date_format

  run do
    log_debug 'Would run it'
  end
end
