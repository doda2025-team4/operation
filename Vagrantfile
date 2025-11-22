# Step 1
WORKER_COUNT = ENV.fetch("WORKERS", 2).to_i

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"

  # Controller VM
  config.vm.define "ctrl" do |ctrl|
    # Step 2
    ctrl.vm.hostname = "ctrl"
    ctrl.vm.network "private_network", ip: "192.168.56.100"

    ctrl.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
      vb.cpus   = 1
    end

    # Step 3
    ctrl.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "ansible/general.yaml"
      ansible.extra_vars = { hostname: "ctrl" }
    end

    ctrl.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "ansible/ctrl.yaml"
    end
  end

  # Worker VMs
  (1..WORKER_COUNT).each do |i|
    config.vm.define "node-#{i}" do |node|
      # Step 2
      node.vm.hostname = "node-#{i}"
      node.vm.network "private_network", ip: "192.168.56.#{100 + i}"

      node.vm.provider "virtualbox" do |vb|
        vb.memory = 6144
        vb.cpus   = 2
      end

      # Step 3
      node.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "ansible/general.yaml"
        ansible.extra_vars = { hostname: "node-#{i}" }
      end

      node.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "ansible/node.yaml"
      end
    end
  end
end
