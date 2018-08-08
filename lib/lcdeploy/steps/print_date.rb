defstep :print_date do
  remote_step!

  parameters do
    date_format :string, required: true
  end

  label_param :date_format

  run { "date +'#{@date_format}'" }
end
