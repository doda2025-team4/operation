# Step 1
WORKER_COUNT = 2
CTRL_CPUS    = 1
CTRL_MEMORY  = 4096
WORKER_CPUS  = 2
WORKER_MEMORY = 6144

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"

  # Controller VM
  config.vm.define "ctrl" do |ctrl|
    config.trigger.before :up do |trigger|
      trigger.warn = "removing standard dhcp host interface if existent"
      trigger.run = {inline: "bash -c 'if [ $( VBoxManage list dhcpservers | grep -c vboxnet0 ) != \"0\" ]; then VBoxManage dhcpserver remove --netname HostInterfaceNetworking-vboxnet0; fi'"}
    end
    ctrl.vm.hostname = "ctrl"
    ctrl.vm.network "private_network", ip: "192.168.56.100"

    ctrl.vm.provider "virtualbox" do |vb|
      vb.memory = CTRL_MEMORY
      vb.cpus   = CTRL_CPUS
    end
  end

  # Worker VMs
  (1..WORKER_COUNT).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.hostname = "node-#{i}"
      node.vm.network "private_network", ip: "192.168.56.#{100 + i}"

      node.vm.provider "virtualbox" do |vb|
        vb.memory = WORKER_MEMORY
        vb.cpus   = WORKER_CPUS
      end
    end
  end

  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook       = "ansible/main.yml"
    ansible.groups = {
    "ctrl"  => ["ctrl"],
    "nodes" => (1..WORKER_COUNT).map { |i| "node-#{i}" }
    }
    ansible.extra_vars = {
      worker_count: WORKER_COUNT
    }
  end
  
end
