require 'lcdeploy/internal_dsl'

defstep :run_command do
  remote_step!

  parameters do
    command :string, required: true
    user :string, default: ENV['USER']
  end

  label_param :command

  run do
    puts "Fucking user is #{@user} and command is #{@command}"
    puts "Params #{@params}"
  end
end
