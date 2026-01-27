All repositories belonging to this project are available here:

- **operation:** https://github.com/doda2025-team4/operation
- **app:** https://github.com/doda2025-team4/app
- **app (canary):** https://github.com/doda2025-team4/app/tree/canary
- **model-service:** https://github.com/doda2025-team4/model-service
- **model-service (canary):** https://github.com/doda2025-team4/model-service/tree/canary
- **lib-version:** https://github.com/doda2025-team4/lib-version

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
  Created Maven library `lib-version` with `VersionUtil` with `getVersion()` and `getName()` methods reading from properties file generated during build.
  Verification:  
  - Check: `lib-version\src\main\java\com\github\doda2025_team4\lib\VersionUtil.java`  
  - Check app usage: `app\pom.xml`  
  - Run app and click "Good Sentence" to see version

- **F2 – Library Release Workflow**  
  Automated library packaging and publishing workflow. Triggered on release creation, builds package with `mvn deploy` and publishes to GitHub Packages.  
  Verification:  
  - View workflow: `lib-version/.github/workflows/maven-publish.yml`  
  - Check Actions tab for workflow runs  
  - View published packages in GitHub Packages

- **F3 – Containerization of App & Model**  
  Dockerfiles for Spring Boot app and Flask model service.  
  Verification:  
  - View Dockerfiles: `app/Dockerfile` and `model-service/Dockerfile`  
  - Build images: `docker build -t app app/` and `docker build -t model-service model-service/`

- **F4 – Multi-architecture Container Images**  
  Multi-arch builds (linux/amd64, linux/arm64) using Docker Buildx in release workflows.  
  Verification:  
  - View workflow: `app/.github/workflows/release-image.yml`  
  - Check manifest: `docker manifest inspect ghcr.io/doda2025-team4/app:latest`

- **F5 – Multi-stage Dockerfile**  
  App uses a build stage and runtime stage. Reduces image size by excluding dependencies.  
  Verification:  
  - Check Dockerfile: `app/Dockerfile`

- **F6 – Flexible Containers (ENV-configurable)**  
  Environment variables (`SERVER_PORT`, `MODEL_HOST`, `MODEL_DIR`, `MODEL_SERVICE_PORT`) allow configuration without rebuilding. Overridable with docker-compose and .env.  
  Verification:  
  - Check ENV setup in `app/Dockerfile` and `model-service/Dockerfile`  
  - Check overrides: `operation/.env` and `operation/docker-compose.yml`

- **F7 – Docker Compose Operation**  
  Complete stack with app service, model-service, networking, volumes, and environment variables from `.env`.  
  Verification:  
  - Start stack: `docker compose up`  
  - Check services: `docker compose ps`  
  - Test: `curl http://localhost:8080/sms`

- **F8 – Automated Container Image Releases**  
  Workflows trigger on push to main/canary, determine version from commits, create release, and push multi-arch images to GHCR.  
  Verification:  
  - View workflows: `app/.github/workflows/auto-version.yml` and `model-service/.github/workflows/auto-version.yml`  
  - Check Actions tab and Releases for automated releases

- **F9 – Automated Model Training & Release**  
  Workflow automates data preprocessing, model training, release creation, and artifact upload.  
  Verification:  
  - View workflow: `model-service/.github/workflows/train-release-model.yml`  
  - Trigger manually or check scheduled runs in Actions  
  - Verify `.joblib` files in release artifacts

- **F10 – No Hard-coded Model in Model-Service**  
  Provide the models by either by manually downloading the desired model files or by providing the url where to download them. To manually provide them, download the files (e.g. `model.joblib` and `preprocessor.joblib`) and place them in a folder (e.g. `model-storage`). You have to provide the filenames and folder name to the corresponding environment variables in the docker-compose. To have the application automatically download the files, put the download url in the docker compose environment variables and provide the name of the folder in which you want to have them downloaded.  
  Verification:  
  - Check Dockerfile: `model-service\Dockerfile`  
  - Check dynamic loading: `model-service\src\serve_model.py`  
  - Check config: `operation\helm_chart\values.yaml`

- **F11 – lib-version Pre-release Automation**  
  Workflow triggers on main (`vX.Y.Z`) and pre-relase branch (`vX.Y.Z-branch.N`).  
  Verification:  
  - View workflow: `lib-version/.github/workflows/semantic-versioning.yml`  
  - Check releases for version patterns  
  - Test: Push commit with `feat:` to develop, verify minor bump

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

#### Deployment Options

You can deploy the application to either the **Vagrant cluster** (recommended, with Istio pre-installed) or **Minikube**. To provision the vagrant cluster, you need to have Ansible 2.20+ installed.

##### Option 1: Deploy to Vagrant Cluster (Recommended)

The Vagrant cluster has Istio, MetalLB, and Ingress already configured via `finalization.yml`.

1. **Start the Vagrant cluster:**
   ```bash
   vagrant up
   cd ansible
   ansible-playbook -u vagrant -i 192.168.56.100, finalization.yml
   cd ..
   ```

2. **Connect kubectl to the Vagrant cluster:**
put the absolute path to your kubeconfig file in place of YOUR_PATH
   ```bash
   export KUBECONFIG=YOUR_PATH
   ```


##### Option 2: Deploy to Minikube

1. **Start Minikube:**
   ```bash
   minikube start --memory=6144 --cpus=4
   minikube addons enable ingress
   ```

2. **Install Istio on Minikube:**
   ```bash
   curl -L https://istio.io/downloadIstio | sh -
   cd istio-*
   export PATH=$PWD/bin:$PATH
   istioctl install --set profile=default -y
   cd ..
   ```

#### Configure local DNS (/etc/hosts)
We expose two endpoints:
- `sms.local` → Istio IngressGateway (canary experiment: 90/10 + sticky + rate limit)
- `sms-nginx.local` → Nginx Ingress (stable-only)
#### Vagrant (VM) cluster
```bash
export ISTIO_IP=$(kubectl -n istio-system get svc istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export NGINX_IP=$(kubectl -n ingress-nginx get svc ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
sudo sh -c "sed -i.bak '/ sms.local\$/d; / sms-nginx.local\$/d' /etc/hosts; \
printf '\n# DODA Team4\n%s sms.local\n%s sms-nginx.local\n' \"$ISTIO_IP\" \"$NGINX_IP\" >> /etc/hosts"
```
#### Minikube cluster
Keep `minikube tunnel` running in a separate terminal.
```bash
export ISTIO_IP=$(kubectl -n istio-system get svc istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export NGINX_IP=$(minikube ip)
sudo sh -c "sed -i.bak '/ sms.local\$/d; / sms-nginx.local\$/d' /etc/hosts; \
printf '\n# DODA Team4 (minikube)\n%s sms.local\n%s sms-nginx.local\n' \"$ISTIO_IP\" \"$NGINX_IP\" >> /etc/hosts"
```

Once you have your Kubernetes cluster ready (either Vagrant or Minikube), proceed with the following steps to deploy the application:

3. **Create the SMTP password secret:**
   ```bash
   kubectl create namespace doda
   kubectl -n doda create secret generic alertmanager-smtp --from-literal=SMTP_PASSWORD="ybsuczpfonhkunqy"
   ```

    Alternative option: let Helm **generate the Secret** by setting `smtpSecret.create=true` and providing the password at install/upgrade by adding the following to the `helm install` command:
    ```bash
    --set smtpSecret.create=true --set smtpSecret.smtpPassword='ybsuczpfonhkunqy'
    ```

4. **Enable Istio sidecar injection for the namespace:**
   ```bash
   kubectl label namespace doda istio-injection=enabled --overwrite
   ```

5. **Install the Helm chart:**
   ```bash
   cd helm_chart
   helm dependency update .
   helm install sms-app . -n doda
   ```

**Shared VirtualBox Storage**  
  All VMs mount the same VirtualBox shared folder as `/mnt/shared`. The Helm chart mounts this path into the model-service as a `hostPath` volume so model artifacts persist across pod restarts and across nodes. Stable and canary use separate subdirectories (`/mnt/shared/model-stable` and `/mnt/shared/model-canary`) to avoid overwriting `model.joblib` / `preprocessor.joblib`.  
  Verification:  
  - Provision the VMs.  
  - On **each VM** verify the shared folder is mounted:
    - `mount | grep /mnt/shared`
    - `ls -la /mnt/shared`

  - Verify that model pods mount the volume:
    - `kubectl -n doda describe deploy model-deployment | sed -n '/Mounts:/,/Conditions:/p'`
    - `kubectl -n doda describe deploy model-deployment-canary | sed -n '/Mounts:/,/Conditions:/p'`

  - Verify stable model downloads on first start (should say **Downloading**):
    - `kubectl -n doda logs deploy/model-deployment -c model-container | egrep "\[model-service\] (Downloading|Using existing)"`

  - Scale stable model to create a second pod on another node:
    - `kubectl -n doda scale deploy/model-deployment --replicas=2`
    - `kubectl -n doda get pods -l app=model-service -o wide`

  - Verify the **new** stable pod reuses the existing artifacts (should show **Using existing** instead of **Downloading**):
    - `kubectl -n doda logs <NEW_STABLE_POD_NAME> -c model-container | egrep "\[model-service\] (Downloading|Using existing)"`

#### Prometheus
- **Custom Prometheus Metrics**  
  App service exposes metrics at `/metrics` endpoint. Metrics are defined in in `app/src/main/java/com/team04/app/MetricsConfig.java`: `sms_active_requests` (Gauge), `sms_predictions_total` (Counter), `sms_prediction_latency` (Histogram).  
  Verification:  
  - Check metrics: `curl http://sms.local/metrics`


- **Prometheus Monitoring**  
  Prometheus deployed via `kube-prometheus-stack` dependency. ServiceMonitor in `helm_chart/templates/service-monitor.yml` scrapes app metrics.  
  Verification:  
  - Check pods:
    - `kubectl get pods -n doda`

  - Generate metrics:
    - `curl -X POST http://sms.local/sms \
      -H "Content-Type: application/json" \
      -d '{"sms":"hello"}'`
    - (repeat the request a few times to increase counters)

  - Port-forward Prometheus:
    - `kubectl port-forward svc/sms-app-monitoring-prometheus 9090:9090 -n doda`

  - Open the Prometheus UI:
    - Navigate to: `http://localhost:9090` → tab **"Graph"**

  - Run the following queries:
    - `sms_predictions_total`
    - `sms_active_requests`

#### Grafana

- **Grafana Integration**  
  Grafana deployed as sub-chart with Prometheus datasource auto-configured.  
  Verification:  
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
    - Open the application UI:
      - Navigate to `http://sms-nginx.local/sms`
    - Send a few SMS prediction requests to generate traffic
    - In Grafana, open one of the dashboards and verify that the graphs update accordingly

#### Alerting

View the alertmanager:
  - Port-forward the alertmanager:
    - `kubectl port-forward svc/sms-app-monitoring-alertmanager 9093:9093 -n doda`
  - Open the UI:
    - Navigate to `http://localhost:9093/`

To receive an alert:
  - Replace `replace@me.please` in `values.yml` with the email address you want to receive the alert on
  - Update the helm install
  - Submit more than or equal to 10 sms prediction requests in the application in a minute
  - Wait a few seconds
  - You should now have received an email

### A4

- **Istio Service Mesh Architecture**  
  Istio-based service mesh with IngressGateway (`helm_chart/templates/istio-gateway.yml`), VirtualService (`istio-virtualservice.yml`), and DestinationRules (`istio-destinationrule.yml`). Istio installed through `ansible/finalization.yml`.  
  Verification:  
  - Check Istio: `kubectl get pods -n istio-system`  
  - List resources: `kubectl get gateway,virtualservice,destinationrule -n doda`

- **Request Flow**  
  User request -> IngressGateway (port 80) -> VirtualService (90/10 routing) -> DestinationRule (stable/canary subsets) -> app-service pods -> model-service.  
  Verification:  
  - Check flow: `kubectl get gateway,virtualservice,destinationrule,svc,pods -n doda`  
  - View labels: `kubectl get pods -l app=app-service --show-labels -n doda`

- **Application Access**  
  Hostname `sms.local` on port 80, path `/sms`. Configured in `helm_chart/values.yaml`.  
  Verification:  
  - Test: `curl -i http://sms.local/sms`

- **Canary Deployment (90/10 Split)**  
  90/10 traffic split configured in `helm_chart/templates/istio-virtualservice.yml` via `istio.canary.weight` in values.yaml. Two deployments: `app-deployment` (stable) and `app-deployment-canary` (canary).  
  Verification:  
  - View deployments: `kubectl get deployments -n doda`  

- **Sticky Sessions**  
  Cookie-based routing using `user-experiment` cookie (30 minute ttl). First request gets random assignment, then route to same version.  
  Verification:  
  - Test first request: `curl -i -c cookies.txt http://sms.local/sms`  
  - Test sticky: `curl -i -b cookies.txt http://sms.local/sms`

- **Rate Limiting**  
  Global rate limiting via Istio, Envoy, Redis. Configured in `helm_chart/templates/ratelimit-backend.yml`, `ratelimit-configmap.yml`, and `istio-global-ratelimit-filter.yml`. Enforced at IngressGateway before routing. 10 requests per minute per user (via `x-user-id` header).
  Verification:  
  - Check policy at `operation/helm_chart/values.yaml`
  - Test allowed: `curl -i http://sms.local/sms -H "x-user-id: bob"`  
  - Test exceeded: `for i in {1..11}; do curl -i http://sms.local/sms -H "x-user-id: bob"; done`  

