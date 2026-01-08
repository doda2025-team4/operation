All repositories belonging to this project are available here:

- **app:** https://github.com/doda2025-team4/app/tree/A2
- **model-service:** https://github.com/doda2025-team4/model-service/tree/A2
- **lib-version:** https://github.com/doda2025-team4/lib-version/tree/A2

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
  Provide the models by either by manually downloading the desired model files or by providing the url where to download them. To manually provide them, download the files (e.g. `model.joblib` and `preprocessor.joblib`) and place them in a folder (e.g. `model-storage`). You have to provide the filenames and folder name to the corresponding environment variables in the docker-compose. To have the application automatically download the files, put the download url in the docker compose environment variables and provide the name of the folder in which you want to have them downloaded.

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

- **Step 13 - Initialize Kubernetes Cluster (kubeadm init)**  
  Implemented in `ctrl.yaml`.  
  Verification:  
  `vagrant ssh ctrl -c "kubectl get nodes"`

- **Step 14 - Setup kubectl Configuration**  
  Implemented in `ctrl.yaml`.  
  Verification:  
  `vagrant ssh ctrl -c "kubectl get pods -A"`

- **Step 15 - Install Flannel CNI**  
  Implemented in `ctrl.yaml`.
  Verification:  
  `vagrant ssh ctrl -c "kubectl get pods -n kube-flannel"`
  
  `vagrant ssh ctrl -c "kubectl get daemonset kube-flannel-ds -n kube-flannel"`

- **Step 16 – Install Helm**  
  Implemented in `ctrl.yaml`.  
  Verification:  
  `vagrant ssh ctrl -c "helm version"`

- **Step 17 – Install Helm Diff Plugin**  
  Implemented in `ctrl.yaml`.  
  Verification:  
  `vagrant ssh ctrl -c "helm plugin list"`

- **Step 18 – Generate Join Command for Workers**  
  Implemented in `node.yaml`.  
  Verification:  
  `vagrant ssh ctrl -c "kubeadm token create --print-join-command"`

- **Step 19 – Worker Node Join**  
  Implemented in `node.yaml`.  
  Verification:  
  `vagrant ssh ctrl -c "kubectl get nodes"`
  Note: This did not initially work due to a conflicting IPv4 address with the VirtualBox DHCP Server. [This](https://stackoverflow.com/questions/70675062/vagrant-with-virtualbox-does-not-start-because-of-standard-dhcp-vboxnet0-on-ub) is the source of the solution.

- **Step 20 – Install MetalLB**  
  Implemented in `finalization.yml`.  
  Verification:  
  `vagrant ssh ctrl -c "kubectl get pods -n metallb-system"`  
  `vagrant ssh ctrl -c "kubectl get ipaddresspools.metallb.io -n metallb-system"`

- **Step 21 – Install Nginx Ingress Controller**  
  Implemented in `finalization.yml`. 
  Verification:  
  `vagrant ssh ctrl -c "kubectl get svc -n ingress-nginx"`  
  `vagrant ssh ctrl -c "kubectl get pods -n ingress-nginx"`

- **Step 22 – Install Kubernetes Dashboard + TLS + Ingress**  
  Implemented in `finalization.yml`.  
  Verification:  
  - Check dashboard components:  
    `vagrant ssh ctrl -c "kubectl get pods -n kubernetes-dashboard"`  
  - Check TLS Secret exists:  
    `vagrant ssh ctrl -c "kubectl get secret dashboard-tls -n kubernetes-dashboard"`  
  - Check Ingress host and IP:  
    `vagrant ssh ctrl -c "kubectl get ingress -n kubernetes-dashboard"`  
  - Generate login token:  
    `vagrant ssh ctrl -c "kubectl -n kubernetes-dashboard create token admin-user"`  
  - Open Dashboard in browser:  
    [dashboard.local](https://dashboard.local-192-168-56-90.sslip.io)  
    Click **Advanced** → **Continue** and paste the token at login.

- **Step 23 – Install Istio**  
  Implemented in `finalization.yml`. 
  Verification:  
  `vagrant ssh ctrl -c "kubectl get pods -n istio-system"`  
  `vagrant ssh ctrl -c "kubectl get svc -n istio-system"`  
  `vagrant ssh ctrl -c "istioctl version"`

### A3

#### Monitoring

The monitoring with Prometheus can be verified by:

- Start Minikube:
  - `minikube start --memory=6144 --cpus=4` (reduce if needed)
  - `minikube addons enable ingress`

- Install the Helm chart:
  - `cd helm_chart`
  - `helm dependency update .`
  - `kubectl create namespace doda`
  - `helm install sms-app . -n doda`

- Check pods:
  - `kubectl get pods -n doda`

- Port-forward the app and generate metrics:
  - `kubectl port-forward svc/app-service 8080:8080 -n doda`
  - `curl -X POST http://localhost:8080/sms \
     -H "Content-Type: application/json" \
     -d '{"sms":"hello"}'`
  - (repeat the request a few times to increase counters)

- Port-forward Prometheus:
  - `kubectl port-forward svc/prometheus-sms-app-monitoring-prometheus 9090:9090 -n doda`

- Open the Prometheus UI:
  - Navigate to: `http://localhost:9090` → tab **"Graph"**

- Run the following queries:
  - `sms_predictions_total`
  - `sms_active_requests`

#### Grafana

Grafana can be verified as follows:

- Check that the Grafana pod is running:
  - `kubectl get pods -n doda | grep grafana`

- Port-forward the Grafana service:
  - `kubectl port-forward svc/sms-app-grafana 3000:80 -n doda`

- Open the Grafana UI:
  - Navigate to: `http://localhost:3000`

- Retrieve the admin password:
  - `kubectl get secret -n doda sms-app-grafana -o jsonpath="{.data.admin-password}" | base64 -d; echo`

- Login to Grafana:
  - **Username:** `admin`
  - **Password:** retrieved from the command above

- Verify application metrics in Grafana:
  - Port-forward the app service:
    - `kubectl port-forward svc/app-service 8080:8080 -n doda`
  - Open the application UI:
    - Navigate to `http://localhost:8080/sms`
  - Send a few SMS prediction requests to generate traffic
  - In Grafana, open one of the dashboards and verify that the graphs update accordingly

### A4

#### Deployment
The deployment consists of:
- **Istio IngressGateway (istio-gateway):** Entry point for all external HTTP traffic into the cluster
- **Istio VirtualService (istio-virtualservice):** Defines how incoming traffic is routed to the application and the canary traffic split
- **Istio DestinationRules (istio-destinationrule)**: Defines the stable and canary for app-service, and helps maintain consistent routing between versions
- **app-service**: The externally available application
- **model-service**: The internal backend service
- **Prometheus & Grafana**: Collects and and visualize application metrics

Istio is installed during provisioning is referenced by the Helm chart, which deploys all resources.

#### Which hostnames/ports/paths/headers/... are required to access your application?
- **Hostnames:** dodateam4-app, configured via Helm in values.yaml
- **Port:** By default on port 8080, can be configured for external access
- **Path:** /sms
- **Headers:** None headers are required for normal usage

#### Which path does a typical request take through your deployment?
- **User Request:** User hits the app via http://sms.local/sms
- **IngressGateway:** Traffic enters through the Istio IngressGateway
- **VirtualService:** Request is routed based on the 90/10 split defined in istio-virtualservice.yaml
- **DestinationRule:** Ensures the request is directed to stable or canary

####  Where is the 90/10 split configured? Where is the routing decision taken
- The 90/10 split defined in istio-virtualservice.yaml, from Values.istio.canary.weight. 90% stable, 10% canary

#### Sticky Sessions
- Sticky sessions ensure that once a user is routed to a specific version (stable or canary), they continue to see that version on subsequent requests.
- 1. The first request is routed based on the configured weights (90/10)
- 2. A cookie is set (`user-experiment`) to  identify the selected subset
- 3. Subsequent requests from the same user are then routed to the same subset
- 4. By default the Cookie TTL is 30 minutes

**Configuration in `values.yaml`:**
- `istio.canary.cookieName` - Name of the sticky session cookie
- `istio.canary.cookieTtl` - Cookie time-to-live


#### Verification

```bash
kubectl get gateway,virtualservice,destinationrule
kubectl get pods -l app=app-service --show-labels
```

- Test Normal Request
```bash
curl -v -H "Host: sms.local" http://<INGRESS_IP>/sms/
```

- Test Sticky Sessions
```bash
# First request (saves cookie)
curl -c cookies.txt -H "Host: sms.local" http://<INGRESS_IP>/sms/

# Subsequent requests (should hit same version)
curl -b cookies.txt -H "Host: sms.local" http://<INGRESS_IP>/sms/
```

####  Which component implements the additional use case
- The additional use case is implemented through Istio VirtualService and DestinationRules. TODO