require 'shellwords'
require 'open3'

module VagrantPlugins
  module MutagenProject
    module Mutagen
      def enabled?
        @machine.config.mutagen.orchestrate == true
      end

      def start_daemon
        out, status = Open3.capture2e('mutagen daemon start')
        return if status.success?

        @ui.error "[vagrant-mutagen-project] Failed to start mutagen daemon: #{out}"
      end

      def start_project
        start_daemon

        project_file = @machine.config.mutagen.project_file
        escaped_project_file = Shellwords.escape(project_file)

        _, status = Open3.capture2e("mutagen project list -f #{escaped_project_file}")
        return if status.success?

        @ui.info "[vagrant-mutagen-project] Starting mutagen project orchestration (config: #{project_file})"
        out, status = Open3.capture2e("mutagen project start -f #{escaped_project_file}")
        return if status.success?

        @ui.error "[vagrant-mutagen-project] Failed to start mutagen project: #{out}"
      end

      def terminate_project
        project_file = @machine.config.mutagen.project_file
        escaped_project_file = Shellwords.escape(project_file)

        _, status = Open3.capture2e("mutagen project list -f #{escaped_project_file}")
        return unless status.success?

        @ui.info '[vagrant-mutagen-project] Stopping mutagen project orchestration'
        out, status = Open3.capture2e("mutagen project terminate -f #{escaped_project_file}")
        return if status.success?

        @ui.error "[vagrant-mutagen-project] Failed to terminate mutagen project: #{out}"
      end

      def pause_project
        project_file = @machine.config.mutagen.project_file
        escaped_project_file = Shellwords.escape(project_file)

        out, status = Open3.capture2e("mutagen project pause -f #{escaped_project_file}")
        return if status.success?

        @ui.error "[vagrant-mutagen-project] Failed to pause mutagen project: #{out}"
      end

      def resume_project
        project_file = @machine.config.mutagen.project_file
        escaped_project_file = Shellwords.escape(project_file)

        out, status = Open3.capture2e("mutagen project resume -f #{escaped_project_file}")
        return if status.success?

        @ui.error "[vagrant-mutagen-project] Failed to resume mutagen project: #{out}"
      end
    end
  end
end
