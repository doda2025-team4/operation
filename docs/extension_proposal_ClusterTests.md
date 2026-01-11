# Extension Proposal: Cluster-Level Helm Testing in CI/CD Pipelines

## 1. Current Workflow

In the current project setup, Helm charts are used to deploy the system on Kubernetes, the validation of these charts is primarily performed through manual deployments on a locally provisioned cluster.

This workflow requires developers to manually install or upgrade Helm releases and verify correctness by inspecting runtime behavior.

## 2. Identified Issue

This approach makes deployment validation dependent on manual checks.
Helm templates may render without errors but still produce invalid Kubernetes manifests or fail at runtime due to missing resources, incorrect API versions, or misconfigured probes and permissions.

## 3. Proposed Implementation

This extension proposes introducing a layered CI/CD pipeline that automatically validates Helm charts at both the manifest and cluster level. The pipeline combines static validation, schema conformance checks, and runtime testing in an ephemeral Kubernetes cluster.

In the first stage, static Helm checks are executed using `helm lint` to validate chart structure and best practices. The chart is then rendered using `helm template`, and the resulting Kubernetes manifests are validated against official Kubernetes API schemas using kubeconform. This ensures that generated resources are syntactically and semantically valid before interacting with a cluster.

In the second stage, an ephemeral Kubernetes cluster is created using kind. The Helm chart is installed into this cluster using `helm upgrade --install`. After installation, Helm test hooks defined in the chart are executed using `helm test`. These hooks deploy test Pods or Jobs that perform runtime checks, such as verifying service reachability or application health endpoints.

Test hooks can be implemented in a feature-oriented manner. For example, dedicated hooks can validate monitoring integration (Prometheus metrics exposure, Grafana dashboards), alerting configuration, or routing and experimentation logic. This makes the testing strategy extensible and ensures that new features are accompanied by corresponding runtime validation.

## 4. Expected Benefits

By integrating both static and cluster-level validation into CI, this pipeline detects deployment errors earlier and reduces the need for manual debugging. Invalid manifests and configuration issues are caught before deployment, while runtime failures are identified through automated Helm tests.

From a release engineering perspective, the proposed solution reduces operational toil and increases confidence in deployment changes.

### Example: CI Pipeline for Helm Cluster Testing

```bash
# Static validation
helm lint charts/<chart-name>
helm template charts/<chart-name> | kubeconform -strict

# Ephemeral cluster setup
kind create cluster --name ci-test

# Install and runtime validation
helm upgrade --install test-release charts/<chart-name>
kubectl wait --for=condition=Ready pods --all --timeout=120s
helm test test-release

# Cleanup
kind delete cluster --name ci-test
```

### Example: Monitoring Validation via Helm Test Hooks

Monitoring-related features can be validated through dedicated Helm test hooks that run during `helm test`.

This hook verifies that the application exposes a Prometheus-compatible metrics endpoint and that it is reachable through the Kubernetes Service.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: "{{ .Release.Name }}-metrics-test"
  annotations:
    "helm.sh/hook": test
spec:
  restartPolicy: Never
  containers:
    - name: curl
      image: curlimages/curl:8.5.0
      args:
        - /bin/sh
        - -c
        - >
          curl -sf http://{{ .Release.Name }}-frontend:8080/actuator/prometheus >/dev/null
```

## 5. References

- Helm Documentation – Chart Testing and Hooks  
  https://helm.sh/docs/topics/chart_tests/

- Helm Documentation – Linting Charts  
  https://helm.sh/docs/helm/helm_lint/

- kubeconform – Kubernetes Schema Validation  
  https://github.com/yannh/kubeconform

- kind – Kubernetes in Docker (Testing Kubernetes)  
  https://kind.sigs.k8s.io/docs/user/quick-start/