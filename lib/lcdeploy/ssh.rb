require 'net/ssh'

require 'lcdeploy/logging'

class Net::SSH::Connection::Session
  def exec(cmd)
    stdout = ''
    stderr = ''
    rv = nil

    open_channel do |chan|
      chan.exec(cmd) do |_, success|
        raise CommandExecutionFailed, "Command #{cmd} failed to execute" \
          unless success

        chan.on_data { |_, data| stdout += data }
        chan.on_extended_data { |_, _, data| stderr += data }
        chan.on_request('exit-status') { |_, data| rv = data.read_long }
      end
    end

    loop

    LCD::SSH::SSHCommandResult.new cmd: cmd,
                                   stdout: stdout.chomp,
                                   stderr: stderr.chomp,
                                   exit_code: rv
  end

  class CommandExecutionFailed < StandardError
  end
  class CommandFailed < StandardError
  end
end

module LCD
  module SSH
    def self.ssh_exec(cmd, ssh_config = {})
      user, port, host = ssh_config.values_at(:user, :port, :host)

      opts = { port: port }
      if (password = ssh_config[:password])
        opts[:password] = password
      elsif (ssh_key = ssh_config[:ssh_key])
        opts[:keys] = [ssh_key]
      end

      Net::SSH.start(host, user, opts) { |ssh| ssh.exec(cmd) }
    end

    def self.ssh_check(cmd, ssh_config = {})
      ssh_exec(cmd, ssh_config).success?
    end

    # TODO: CommandResult superclass?
    class SSHCommandResult
      attr_reader :cmd, :stdout, :stderr, :exit_code

      def initialize(result = {})
        @cmd = result[:cmd]
        @stdout = result[:stdout]
        @stderr = result[:stderr]
        @exit_code = result[:exit_code]
      end

      def success?
        @exit_code.zero?
      end

      def to_h
        {
          cmd: @cmd,
          stdout: @stdout,
          stderr: @stderr,
          exit_code: @exit_code,
          success: success?
        }
      end
    end
  end
end
