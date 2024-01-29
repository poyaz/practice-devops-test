# -*- mode: ruby -*-
# vi: set ft=ruby :

REQUIRED_PLUGINS = %w(vagrant-libvirt)
exit unless REQUIRED_PLUGINS.all? do |plugin|
  Vagrant.has_plugin?(plugin) || (
    puts "The #{plugin} plugin is required. Please install it with:"
    puts "$ vagrant plugin install #{plugin}"
    false
  )
end

if ARGV.include?("up") or (ARGV.include?("snapshot") and ARGV.include?("restore"))
  ENV["VAGRANT_EXPERIMENTAL"] = "typed_triggers"
end

snapshot_machine_name_list = []
Vagrant.configure("2") do |config|
  config.trigger.after :"VagrantPlugins::ProviderLibvirt::Action::SnapshotRestore", type: :action do |t|
    t.run_remote = {
      inline:
        <<-SHELL
          hwclock --hctosys
        SHELL
    }
  end

  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"
  config.ssh.insert_key = false

  config.trigger.after :up do |t|
    t.info = "Disable systemd-resolve and install required dependency"
    t.run_remote = {
      inline:
        <<-SHELL
          systemctl is-active --quiet systemd-resolved.service \
            && (\
              systemctl stop systemd-resolved.service \
              && systemctl disable systemd-resolved.service \
              && rm -rf /etc/resolv.conf \
              && echo -e "nameserver 4.2.2.1\nnameserver 4.2.2.2\nsearch ." > /etc/resolv.conf \
            )

          hwclock --hctosys
        SHELL
    }
  end

  config.vm.define "k8s-test" do |m|
    m.vm.box = "generic/ubuntu2204"
    m.vm.hostname = "k8s-test"

    m.vm.provider :libvirt do |vb|
      vb.memory = 4048
      vb.cpus = 2
    end
  end

end

