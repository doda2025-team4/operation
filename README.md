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

You can deploy the application to either the **Vagrant cluster** (recommended, with Istio pre-installed) or **Minikube**.

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

3. **Install the Helm chart:**
   ```bash
   cd helm_chart
   helm dependency update .
   kubectl create namespace doda
   helm install sms-app . -n doda
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

3. **Install the Helm chart:**
   ```bash
   cd helm_chart
   helm dependency update .
   kubectl create namespace doda


#### Prometheus
- **Custom Prometheus Metrics**  
  App service exposes metrics at `/metrics` endpoint. Metrics are defined in in `app/src/main/java/com/team04/app/MetricsConfig.java`: `sms_active_requests` (Gauge), `sms_predictions_total` (Counter), `sms_prediction_latency` (Histogram).  
  Verification:  
  - Check metrics: `curl http://localhost:8080/metrics


- **Prometheus Monitoring**  
  Prometheus deployed via `kube-prometheus-stack` dependency. ServiceMonitor in `helm_chart/templates/service-monitor.yml` scrapes app metrics.  
  Verification:  
  - Check pods:
    - `kubectl get pods -n doda`

  - Port-forward the app and generate metrics:
    - `kubectl port-forward svc/app-service 8080:8080 -n doda`
    - `curl -X POST http://localhost:8080/sms \
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
    - Port-forward the app service:
      - `kubectl port-forward svc/app-service 8080:8080 -n doda`
    - Open the application UI:
      - Navigate to `http://localhost:8080/sms`
    - Send a few SMS prediction requests to generate traffic
    - In Grafana, open one of the dashboards and verify that the graphs update accordingly

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
  - Test: `curl -H "Host: sms.local" http://<INGRESS_IP>/sms/`

- **Canary Deployment (90/10 Split)**  
  90/10 traffic split configured in `helm_chart/templates/istio-virtualservice.yml` via `istio.canary.weight` in values.yaml. Two deployments: `app-deployment` (stable) and `app-deployment-canary` (canary).  
  Verification:  
  - View deployments: `kubectl get deployments -n doda`  

- **Sticky Sessions**  
  Cookie-based routing using `user-experiment` cookie (30 minute ttl). First request gets random assignment, then route to same version.  
  Verification:  
  - Test first request: `curl -c cookies.txt -H "Host: sms.local" http://<INGRESS_IP>/sms/`  
  - Test sticky: `curl -b cookies.txt -H "Host: sms.local" http://<INGRESS_IP>/sms/`

- **Rate Limiting**  
  Global rate limiting via Istio, Envoy, Redis. Configured in `helm_chart/templates/ratelimit-backend.yml`, `ratelimit-configmap.yml`, and `istio-global-ratelimit-filter.yml`. Enforced at IngressGateway before routing. 10 requests per minute per user (via `x-user-id` header).
  Verification:  
  - Check policy at `operation/helm_chart/values.yaml`
  - Test allowed: `curl -H "Host: sms.local" -H "x-user-id: bob" http://<INGRESS_IP>/sms`  
  - Test exceeded: `for i in {1..11}; do curl -H "Host: sms.local" -H "x-user-id: bob" http://<INGRESS_IP>/sms; done`  

#### Deployment
The deployment consists of:
- **Istio IngressGateway (istio-gateway):** Entry point for all external HTTP traffic into the cluster
- **Istio VirtualService (istio-virtualservice):** Defines how incoming traffic is routed to the application and the canary traffic split
- **Istio DestinationRules (istio-destinationrule)**: Defines the stable and canary for app-service, and helps maintain consistent routing between versions
- **app-service**: The externally available application
- **model-service**: The internal backend service
- **Prometheus & Grafana**: Collects and and visualize application metrics

Istio is installed during provisioning is referenced by the Helm chart, which deploys all resources.

Implemented in: `operation/helm_chart/templates/istio-gateway.yml`, `operation/helm_chart/templates/istio-virtualservice.yml`, `operation/helm_chart/templates/istio-destinationrule.yml`

**Architecture diagram:**
"ADD DIAGRAM SHOWING SPLIT HERE"

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

### Additional Use Case - Rate Limiting
The additional use case of rate limiting incoming requests was chosen for our project. Global rate limiting is implemented using **Istio + Envoy** and uses **Redis** to store the rate limit state across the cluster. It is evaluated at the Istio IngressGateway **before** canary routing and sticky session logic are applied.

Implemented in: `operation/helm_chart/templates/ratelimit-backend.yml`, `operation/helm_chart/templates/ratelimit-configmap.yml`, `operation/helm_chart/templates/istio-global-ratelimit-filter.yml`

### How rate limiting works
1. A client sends a request to the application via the Istio IngressGateway.
2. Envoy extracts the `x-user-id` HTTP header from the request.
3. Envoy synchronously queries the Rate Limit Service via gRPC.
4. Redis is used to check whether the request exceeds the allowed quota.
5. Decision:
   * If allowed → request proceeds to normal routing (VirtualService / DestinationRule).
   * If exceeded → Envoy immediately returns **HTTP 429 (Too Many Requests)**.

Rate limiting is therefore **global, centralized, and enforced at ingress**.

**Important:** If the `x-user-id` header is not provided, all such requests are grouped under the same rate-limit bucket.

### Rate limit policy
The rate limit policy is defined via `values.yaml` and rendered into a ConfigMap:
* **10 requests per minute**
* **per user**, identified by the `x-user-id` request header
* **cluster-wide**, across all pods and replicas

### Verification
- Allowed requests:
```bash
curl -H "Host: sms.local" -H "x-user-id: alice" http://<INGRESS_IP>/sms
```
Expected response: **HTTP 200**

- Exceed rate limit:
```bash
for i in {1..11}; do
  curl -H "Host: sms.local" -H "x-user-id: alice" http://<INGRESS_IP>/sms
done
```
Expected response: **HTTP 429**

- Different user (separate quota):
```bash
curl -H "Host: sms.local" -H "x-user-id: bob" http://<INGRESS_IP>/sms
```
Expected response: **HTTP 200**
