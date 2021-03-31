require 'shellwords'
require 'open3'
require 'fileutils'

module VagrantPlugins
  module MutagenProject
    module SSHConfig
      SSH_CONFIG_PATH = File.expand_path('~/.ssh/config')
      SSH_CONFIG_DIR = File.dirname(SSH_CONFIG_PATH)

      def add_machine_to_ssh_config
        @ui.info '[vagrant-mutagen-project] Adding machine to SSH config'

        # Ensure the full path exists
        FileUtils.mkdir_p(SSH_CONFIG_DIR)

        # Update the config
        File.open(SSH_CONFIG_PATH, File::CREAT | File::LOCK_EX | File::RDWR) do |file|
          # Read the file
          contents = file.read

          # Add config, replacing any existing config
          signature = generate_signature(@machine.name, @machine.id)
          contents.gsub!(config_entry_pattern(signature), '')

          contents << "\n\n" unless contents.empty?
          contents << config_entry(signature, @machine.name, @machine.config.vm.hostname)

          # Replace the file
          file.rewind
          file.truncate(0)
          file.write(contents)
        end
      end

      def remove_machine_from_ssh_config
        @ui.info '[vagrant-mutagen-project] Removing machine from SSH config'

        if File.exists?(SSH_CONFIG_PATH)
          File.open(SSH_CONFIG_PATH, File::LOCK_EX | File::RDWR) do |file|
            # Read the file
            contents = file.read

            # Remove the config
            signature = generate_signature(@machine.name, @machine.id)
            contents.gsub!(config_entry_pattern(signature), "\n\n")
            contents.gsub!(/(\A\s+|\s+\z$)/, '')

            # Replace the file
            file.rewind
            file.truncate(0)
            file.write(contents)
          end
        end
      end

      def generate_signature(name, uuid)
        hashed_id = Digest::MD5.hexdigest(uuid)
        "# VAGRANT: #{hashed_id} (#{name}) / #{uuid}"
      end

      def config_entry_pattern(signature)
        escaped_signature = Regexp.escape(signature)
        Regexp.new(/(\s|\n)*#{escaped_signature}.*?#{escaped_signature}(\s|\n)*/m)
      end

      def config_entry(signature, name, hostname)
        # Get the SSH config from Vagrant
        command = "vagrant ssh-config #{Shellwords.escape(name)} --host #{Shellwords.escape(hostname)}"
        ssh_config, = Open3.capture2({ 'VAGRANT_INSTALLER_ENV' => '' }, command)
        ssh_config.gsub!(/(\A\s+|\s+\z$)/, '')

        # Return the entry
        "#{signature}\n#{ssh_config}\n#{signature}"
      end
    end
  end
end
