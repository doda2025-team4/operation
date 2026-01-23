# Extension Proposal: Cross-Repository Version Management for Reproducible Releases

## 1. Current Workflow

The project follows a multi-repository structure in which application components are developed and released independently, while deployment logic is centralized in the operation repository. Container images are manually built and pushed to the GitHub Container Registry using semantic version tags. After publishing these images, developers must manually update the corresponding image tags in the Helm values files before deploying the system.

## 2. Identified Issue

This workflow requires developers to coordinate changes across repositories during release time. Although versioning conventions are respected, the effective system version is never declared explicitly in a single place and must instead be inferred by inspecting multiple repositories. As a result, deployments are difficult to reproduce and error-prone to manage.

Furthermore, the current approach conflicts with established container deployment best practices. Official Kubernetes documentation explicitly warns against the use of floating image tags such as `latest`, as they obscure which version is actually running and make rollbacks unreliable. Similarly, Helm best practices recommend using fixed image tags or immutable image digests to ensure traceability and reproducibility.

Without a single declarative source of truth for deployment state, it becomes difficult to audit changes, reproduce experiments, or reliably answer which versions were running at a given point in time.

## 3. Proposed Implementation

The core idea is to explicitly declare the system state in a versioned release manifest, system-level Bill of Materials (BOM).
In this context, the BOM serves as the single authoritative description of which artifact versions and configurations constitute a deployable system snapshot.

Each application repository (e.g., app and model-service) is treated as an artifact producer. On every push to a release branch or tag, a CI workflow automatically builds and publishes a versioned container image. Once the image is available, the workflow triggers a cross-repository action that opens a pull request against the operation repository. This pull request updates the release manifest or Helm values with the newly produced image version or immutable digest.

Cross-repository automation can be implemented using GitHub Actions and the `repository_dispatch` event, which is explicitly designed to trigger workflows based on activity outside the target repository. This allows version updates to be propagated automatically without manual intervention, while still preserving human control via pull request review.

## 4. Expected Benefits

The proposed solution removes manual coordination steps from the release process and establishes the operation repository as the single source of truth for deployment state. This significantly improves traceability, reproducibility, and confidence in deployments.

### Example: Reproducible System Snapshot

The following release manifest represents a complete snapshot of the system state, explicitly defining which service versions and experiment configuration are deployed.

```yaml
release: system-2026-01-11-expA
images:
  app:
    repo: ghcr.io/<org>/app
    tag: v1.2.3
  modelService:
    repo: ghcr.io/<org>/model-service
    tag: v2.0.1
experiment:
  istio:
    canaryWeight: 10
    stableWeight: 90
```

Reproducing this deployment only requires checking out the corresponding commit in the operation repository and redeploying via Helm:

```bash
git checkout <commit-sha>
helm dependency build charts/<chart-name>
helm upgrade --install my-release charts/<chart-name> \
  -f releases/system-2026-01-11-expA.values.yaml
```

## 5. References

- Kubernetes Documentation – Container Images:  
  “You should avoid using the :latest tag when deploying containers in production as it is harder to track which version of the image is running and more difficult to roll back properly.”  
  https://kubernetes.io/docs/concepts/containers/images/

- Helm Best Practices – Images:  
  “A container image should use a fixed tag or the SHA of the image. It should not use the tags latest, head, canary, or other tags that are designed to be floating.”  
  https://helm.sh/docs/chart_best_practices/pods/#images

- GitHub Actions Documentation – `repository_dispatch`:  
  “A webhook event for triggering workflows for activity outside GitHub.”  
  https://docs.github.com/actions/learn-github-actions/events-that-trigger-workflows#repository_dispatch

- OpenGitOps Principles – Declarative and Versioned System State  
  https://opengitops.dev/
