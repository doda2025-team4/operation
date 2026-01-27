# Step 1
WORKER_COUNT = 2
CTRL_CPUS    = 1
CTRL_MEMORY  = 4096
WORKER_CPUS  = 2
WORKER_MEMORY = 6144

INVENTORY_PATH = File.join(__dir__, "ansible", "inventory.cfg")

def write_inventory(path, worker_count)
  File.open(path, "w") do |f|
    f.puts "ctrl ansible_host=192.168.56.100 ansible_user=vagrant ansible_port=22 ansible_ssh_private_key_file=#{File.join(__dir__, ".vagrant/machines/ctrl/virtualbox/private_key")}"

    (1..worker_count).each do |i|
      f.puts "node-#{i} ansible_host=192.168.56.#{100 + i} ansible_user=vagrant ansible_port=22 ansible_ssh_private_key_file=#{File.join(__dir__, ".vagrant/machines/node-#{i}/virtualbox/private_key")}"
    end

    f.puts "\n[ctrl]\nctrl\n\n[nodes]"
    (1..worker_count).each { |i| f.puts "node-#{i}" }
  end
end

write_inventory(INVENTORY_PATH, WORKER_COUNT)

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"

  # Shared folder for "Excellent" requirement (mounted on ALL VMs)
  SHARED_DIR = File.join(__dir__, "shared")
  Dir.mkdir(SHARED_DIR) unless Dir.exist?(SHARED_DIR)

  # Controller VM
  config.vm.define "ctrl" do |ctrl|
    config.trigger.before :up do |trigger|
      trigger.warn = "removing standard dhcp host interface if existent"
      trigger.run = { inline: "bash -c 'if [ $( VBoxManage list dhcpservers | grep -c vboxnet0 ) != \"0\" ]; then VBoxManage dhcpserver remove --netname HostInterfaceNetworking-vboxnet0; fi'" }
    end

    ctrl.vm.hostname = "ctrl"
    ctrl.vm.network "private_network", ip: "192.168.56.100"

     # Mount shared folder on ctrl
    ctrl.vm.synced_folder SHARED_DIR, "/mnt/shared",
      type: "virtualbox",
      owner: "vagrant",
      group: "vagrant",
      mount_options: ["dmode=775", "fmode=664"]

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

      # Mount shared folder on worker
      node.vm.synced_folder SHARED_DIR, "/mnt/shared",
        type: "virtualbox",
        owner: "vagrant",
        group: "vagrant",
        mount_options: ["dmode=775", "fmode=664"]

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
