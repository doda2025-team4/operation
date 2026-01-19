WORKER_COUNT = 2
CTRL_CPUS    = 1
CTRL_MEMORY  = 4096
WORKER_CPUS  = 2
WORKER_MEMORY = 6144

INVENTORY_PATH = "ansible/inventory.cfg"

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"

  config.vm.define "ctrl" do |ctrl|
    ctrl.vm.hostname = "ctrl"
    ctrl.vm.network "private_network", ip: "192.168.56.100"
    ctrl.vm.provider "virtualbox" do |vb|
      vb.memory = CTRL_MEMORY
      vb.cpus   = CTRL_CPUS
    end
  end

  (1..WORKER_COUNT).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.hostname = "node-#{i}"
      node.vm.network "private_network", ip: "192.168.56.#{100 + i}"
      node.vm.provider "virtualbox" do |vb|
        vb.memory = WORKER_MEMORY
        vb.cpus   = WORKER_CPUS
      end

      if i == WORKER_COUNT
        node.trigger.after :up do |trigger|
          trigger.ruby do
            File.open(INVENTORY_PATH, 'w') do |f|
              f.puts "ctrl ansible_host=192.168.56.100 ansible_port=22 ansible_user='vagrant' ansible_ssh_private_key_file='/vagrant/.vagrant/machines/ctrl/virtualbox/private_key'"
              (1..WORKER_COUNT).each do |j|
                f.puts "node-#{j} ansible_host=192.168.56.#{100 + j} ansible_port=22 ansible_user='vagrant' ansible_ssh_private_key_file='/vagrant/.vagrant/machines/node-#{j}/virtualbox/private_key'"
              end
              f.puts "\n[ctrl]\nctrl\n\n[nodes]"
              (1..WORKER_COUNT).each do |j|
                f.puts "node-#{j}"
              end
              f.puts "\n[all:vars]\nansible_python_interpreter=/usr/bin/python3"
            end
          end
        end

        node.vm.provision "shell", inline: <<-SHELL
          chmod 600 /vagrant/.vagrant/machines/*/virtualbox/private_key 2>/dev/null || true
          mkdir -p /home/vagrant/.ssh
          echo -e "Host 192.168.56.*\n    StrictHostKeyChecking no\n    UserKnownHostsFile=/dev/null" > /home/vagrant/.ssh/config
          chmod 600 /home/vagrant/.ssh/config
          chown vagrant:vagrant /home/vagrant/.ssh/config
        SHELL

        node.vm.provision "ansible_local" do |ansible|
          ansible.playbook       = "ansible/main.yml"
          ansible.inventory_path = INVENTORY_PATH
          ansible.limit          = "all"
          ansible.install_mode   = :default
          ansible.extra_vars = {
            worker_count: WORKER_COUNT
          }
        end
      end
    end
  end
end
