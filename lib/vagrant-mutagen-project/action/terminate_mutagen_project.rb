require_relative '../mutagen'
require_relative '../ssh_config'

module VagrantPlugins
  module MutagenProject
    module Action
      class TerminateMutagenProject
        include Mutagen
        include SSHConfig

        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @ui = env[:ui]
        end

        def call(env)
          if enabled? && destroy_confirmed?(env)
            terminate_project
            remove_machine_from_ssh_config
          end

          @app.call(env)
        end

        def destroy_confirmed?(env)
          env[:force_confirm_destroy_result]
        end
      end
    end
  end
end
