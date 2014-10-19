require Vagrant.source_root.join("plugins/guests/redhat/cap/change_host_name")

# monkeypatch the change_hostname capability of the redhat plugin to
# fix https://github.com/mitchellh/vagrant/issues/4465
module VagrantPlugins
  module GuestRedHat
    module Cap
      class ChangeHostName
        def self.change_host_name(machine, name)
          new(machine, name).change!
        end

        def change!
          return unless should_change?

          case machine.guest.capability("flavor")
          when :rhel_7
            update_hostname_rhel7
            update_etc_hosts
          else
            update_sysconfig
            update_hostname
            update_etc_hosts
            update_dhcp_hostnames
            restart_networking
          end
        end

        def should_change?
          new_hostname != current_hostname
        end

        def update_hostname_rhel7
          sudo "hostnamectl set-hostname #{fqdn}"
        end

      end
    end
  end
end
