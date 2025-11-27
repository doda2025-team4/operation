All repositories belonging to this project are available here:

- **app:** https://github.com/doda2025-team4/app/tree/A1
- **model-service:** https://github.com/doda2025-team4/model-service/tree/A1
- **lib-version:** https://github.com/doda2025-team4/lib-version/tree/A1

Environment variables are both declared in the .env file in this repo and the dockerfiles of app and model-service repositories. If docker-compose is used, the declarations in the dockerfiles are overridden. We wanted to have this design choice to ensure that there are defaults declared in build time as well in case the container was going to be run without the docker-compose.

## Running the Application (Docker Compose)

A `docker-compose.yml` file is included to serve as the starting point for local execution of the application.  

To start the stack (once components are ready):

```bash
docker compose up
```

To start the cluster:

```bash
vagrant up
```

## Features Overview

### A1

- **F1 – Version-aware Library**  
 See [DEVLOG](https://github.com/doda2025-team4/lib-version/blob/A1/DEVLOG.md)

- **F2 – Library Release Workflow**  
  See [DEVLOG](https://github.com/doda2025-team4/lib-version/blob/A1/DEVLOG.md)

- **F3 – Containerization of App & Model**  
  Can be found in Dockerfiles of `app/Dockerfile` and `model-service/Dockerfile`.

- **F4 – Multi-architecture Container Images**  
  Implemented in build workflows under `.github/workflows/release-image.yml` of each service.

- **F5 – Multi-stage Dockerfile**  
    Can be found in Dockerfiles of `app/Dockerfile` and `model-service/Dockerfile`.

- **F6 – Flexible Containers (ENV-configurable)**  
  Implemented with `operation/.env` and `operation/docker-compose.yml`

- **F7 – Docker Compose Operation**  
  Implemented in `operation/docker-compose.yml`.

- **F8 – Automated Container Image Releases**  
  Implemented in workflows under  `.github/workflows/auto-version.yml` of each service.

- **F9 – Automated Model Training & Release**  
  Implemented in workflows under  `.github/workflows/train-release-model.yml` of model service

- **F10 – No Hard-coded Model in Model-Service**  
  Not implemented.

- **F11 – lib-version Pre-release Automation**  
  See [DEVLOG](https://github.com/doda2025-team4/lib-version/blob/A1/DEVLOG.md)

### A2
- **Step 1 - Create VMs**  
  Created VMs `ctrl`, `node-1`, `node-2` with bento/ubuntu-24.04 in Vagrantfile.  
  Verification: `vagrant status`

- **Step 2 - Networking**  
  Configured private network NICs with fixed IPs in Vagrantfile.  
  Verification:  
  `vagrant ssh ctrl -c "ip addr show | grep 192.168.56"`  
  `vagrant ssh node-1 -c "ip addr show | grep 192.168.56"`

- **Step 3 - Provision with Ansible**  
  Added Ansible provisioners for general setup and node/controller-specific playbooks in Vagrantfile.  
  Verification: `vagrant provision`

- **Step 4 - Register SSH Keys**  
  Added "Add team SSH keys" task to `general.yaml` and added "Add team SSH keys" task to `general.yaml`.  
  Verification: `vagrant ssh ctrl -c "cat ~/.ssh/authorized_keys"` shows public keys.

- **Step 5 - Disable SWAP**  
  Added "Disable swap at runtime" and "Remove swap from /etc/fstab" tasks to `general.yaml`.  
  Verification: `vagrant ssh ctrl -c "swapon --show"` shows nothing.

- **Step 6 - br_netfilter**  
  Added "Create modules-load config" and "Load br_netfilter" tasks to `general.yaml`.  
  Verification: `lsmod | grep br_netfilter`.

- **Step 7 - Enable IPv4 forwarding**  
  Added "Enable net.ipv4.ip_forward", "Enable bridged IPv4 forwarding", and "Enable bridged IPv6 forwarding" tasks to `general.yaml`.  
  Verification: `vagrant ssh ctrl -c "sysctl net.ipv4.ip_forward net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables"`

- **Step 8 - Manage /etc/hosts**  
  Added "Generate /etc/hosts dynamically" task to `general.yaml`.  
  Verification: `vagrant ssh ctrl -c "cat /etc/hosts"`

- **Step 9 - Add Kubernetes repository**  
  Added "Add Kubernetes apt key", "Add Kubernetes apt repository", and "Update apt" tasks to `general.yaml`.  
  Verification: `vagrant ssh ctrl -c "apt-cache policy kubeadm"`

- **Step 10 - Install K8s tools**  
  Added "Install required packages" task to `general.yaml`.  
  Verification: `vagrant ssh ctrl -c "dpkg -l | grep kubeadm"`

- **Step 11 - Configure containerd**  
  Added "Ensure containerd config directory exists", "Generate default containerd config", "Disable AppArmor in containerd", "Set sandbox image", "Enable SystemdCgroup", and "Restart containerd" tasks to `general.yaml`.  
  Verification: and `systemctl status containerd`

- **Step 12 - Kubelet**  
  Added "Enable kubelet" task to `general.yaml`.  
  Verification: `vagrant ssh ctrl -c "systemctl status kubelet"`
