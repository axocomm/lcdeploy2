defstep :run_command do
  remote_step!

  parameters do
    command :string, required: true
    user :string, default: ENV['USER']
  end

  label_param :command

  run do
    log_debug "Running command #{@command} as #{@user}"
    @command
  end
end
