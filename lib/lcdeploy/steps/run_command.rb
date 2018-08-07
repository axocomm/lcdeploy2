require 'lcdeploy/internal_dsl'
require 'lcdeploy/logging'

defstep :run_command do
  remote_step!

  parameters do
    command :string, required: true
    user :string, default: ENV['USER']
  end

  label_param :command

  run do
    # log_debug "Using SSH config #{@ssh_config}"
    # log_debug "Running command #{@command} as #{@user}"

    # ssh_exec @command
    puts "Would run #{@command}"
  end
end
