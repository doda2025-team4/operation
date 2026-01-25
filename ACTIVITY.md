### Week Q2.1 (Nov 10+)

- Kasper: 
  - In `lib-version`: [PR 1](https://github.com/doda2025-team4/lib-version/pull/1) up to and including [PR 22](https://github.com/doda2025-team4/lib-version/pull/22).
  - In `app`: [PR 1](https://github.com/doda2025-team4/app/pull/1) up to and including [PR 4](https://github.com/doda2025-team4/app/pull/4). Note, this was not merged to main this week.
  - I have worked on A1 by implementing a solution to F1, F2 and F11.
 
- Noky:
  - Attended the first meeting where we started with the assignment and divided the tasks

- Andrea:
  - Attended first meeting

- Poyraz:
  - Checked out the assignment

- Mohammed:
  - Attended first meeting

- Joshua:
  - Divided assignments and took F8 and F9

### Week Q2.2 (Nov 17+)

- Kasper: 
  - In `lib-version`: [PR 23](https://github.com/doda2025-team4/lib-version/pull/1) up to and including [PR 25](https://github.com/doda2025-team4/lib-version/pull/22).
  - In `app`: Continuation of [PR 1](https://github.com/doda2025-team4/app/pull/1).
  - I have worked on A1 by re-implementing the solution to F1, F2 and F11 without using GitHub Actions Marketplace Workflows.

- Noky:
  - Created the dockerfile for the model-service [PR1](https://github.com/doda2025-team4/model-service/pull/1/)
  - Created the dockerfile for the app [PR5](https://github.com/doda2025-team4/app/pull/5)

- Andrea:
  - Created docker-compose and README in operation repository [PR2](https://github.com/doda2025-team4/operation/pull/2)

- Poyraz:
  - Adjusted the dockerfile and source code for the model-service to incorprate env variables [PR2](https://github.com/doda2025-team4/model-service/pull/2)
  - Adjusted the dockerfile for the app to incorprate env variables [PR6](https://github.com/doda2025-team4/app/pull/6)
  - Added .env file and adjusted the docker-compose file to incorprate env variables [PR3](https://github.com/doda2025-team4/operation/pull/3)

- Mohammed:
  - Implemented F10 in `model-service` so the model is loaded from a `/models` volume or, if missing, downloaded once from a GitHub release URL [PR3](https://github.com/doda2025-team4/model-service/pull/3)
  - Updated `operation`'s `docker-compose.yml` so `model-service` uses the `/models` volume with `MODEL_DIR`, `MODEL_FILE` and `MODEL_URL` environment variables [PR4](https://github.com/doda2025-team4/operation/pull/4)

- Joshua:
  - Implemented F8 in `app` and `model-service` by creating workflows for automated container image builds and releases using automatic semantic versioning and multi-arch Docker image publishing
  - Implemented F9 in `model-service` by creating a workflow for training, versioning, and releasing new models

### Week Q2.3 (Nov 24+)

- Kasper: 
  - In `operation`: [PR 11](https://github.com/doda2025-team4/operation/pull/11).
  - I have worked on A2 by trying to implement the solution to step 18 and step 19. I did not succeed to make it work because of networking issues.

- Noky:
  - I have worked on A2 by implementing step 16 and step 17. [PR10](https://github.com/doda2025-team4/operation/pull/10)

- Poyraz:
  - I have worked on A2 by implementing step 13, 14, and 15. [PR9] (https://github.com/doda2025-team4/operation/pull/9)
  
- Mohammed:
  - I have worked on A2 by implementing step 20. [PR 15](https://github.com/doda2025-team4/operation/pull/15)

- Andrea:
  - I have worked on A2 by fixing the issues encountered in several steps in [PR 8](https://github.com/doda2025-team4/operation/pull/8), [PR 16](https://github.com/doda2025-team4/operation/pull/16), helped in general with reviews in Pull Requests.

- Joshua:
  - In `operation`: [PR 7](https://github.com/doda2025-team4/operation/pull/7).
  - I have worked on A2 by implementing steps 1-12

### Week Q2.4 (Dec 1+)

- Noky:
  - Did the docker to kubernetes migration of assignment 3, [PR24](https://github.com/doda2025-team4/operation/pull/24)

- Mohammed:
  - Refined the F10 implementation by updating `serve_model.py`, cleaning up the Dockerfile (no hard-coded model), adjusting `requirements.txt`, and addressing the review comments in `model-service` and `operation`. [PR3](https://github.com/doda2025-team4/model-service/pull/3)

- Joshua:
  - In `operation`: [PR 26](https://github.com/doda2025-team4/operation/pull/26).
  - I have worked on A3 by implementing alerting. Currently incomplete because Prometheus is not yet integrated.

- Poyraz:
  - Did the helm chart part of assignment 3,[PR25] (https://github.com/doda2025-team4/operation/pull/25)

- Kasper:
  - In `operation`: [PR 23](https://github.com/doda2025-team4/operation/pull/23)
    - Fixed F10 from A1
  - In `app`: [PR 8](https://github.com/doda2025-team4/app/pull/8)
    - Fixed image versioning and release and fixed deployment
  - In `model-service : [PR 5](https://github.com/doda2025-team4/model-service/pull/5)
    - Fixed image versioning and release

- Andrea:
  - I have implemented steps from 21 to 23 for A2 in [PR 18](https://github.com/doda2025-team4/operation/pull/18), worked on "enable monitoring" for A3 in [PR 9](https://github.com/doda2025-team4/app/pull/9) and [PR 30](https://github.com/doda2025-team4/operation/pull/30)

### Week Q2.5 (Dec 8+)

- Andrea:
  - I have worked on implementing "Grafana" for A3 in [PR 41](https://github.com/doda2025-team4/operation/pull/41)

- Poyraz:
  - Did the traffic management part of A4. [PR 42](https://github.com/doda2025-team4/operation/pull/42)

- Joshua:
  - In `app`: [PR 12](https://github.com/doda2025-team4/app/pull/12).
  - I have added input validation and a corresponding new metric
  - In `operation`: [PR 32](https://github.com/doda2025-team4/operation/pull/32).
  - I have worked on A4 by adding the initial setup for istio

- Noky:
  - I have worked on adding a config and secrets map in the helm charts [PR 40](https://github.com/doda2025-team4/operation/pull/40)
 
- Mohammed:
  - Fixed preprocessor loading in `model-service`. [PR 3](https://github.com/doda2025-team4/model-service/pull/3)
  - Updated `docker-compose.yml` with preprocessor variables. [PR 46](https://github.com/doda2025-team4/operation/pull/46)

- Kasper:
  - I have worked on changing our versioning logic to allow the main branch in model-service and app to have both a latest release and a prerelease: [PR 13](https://github.com/doda2025-team4/app/pull/13) and [PR 7](https://github.com/doda2025-team4/model-service/pull/7).
    - This needs to be done to release both versions of the application to do A/B testing.
   
### Week Q2.6 (Dec 15+)  

- Mohammed:
  - Added Vagrant trigger to auto-generate inventory.cfg with active nodes. [PR 48](https://github.com/doda2025-team4/operation/pull/48)

- Andrea:
  - I helped reviewing the open PRs. I couldn’t open a PR myself this week, but I will compensate in week 7

- Joshua:
  - In `operation`: [PR 51](https://github.com/doda2025-team4/operation/pull/51).
  - I have added the outline and documentation for what we have done on A4 so far

- Poyraz:
  - Implemented the base part of rate limiting for additional use case. [PR 53](https://github.com/doda2025-team4/operation/pull/53).

- Kasper:
  - I have completed changing our versioning logic to allow the main branch in model-service and app to have both a latest release and a prerelease: [PR 13](https://github.com/doda2025-team4/app/pull/13) and [PR 7](https://github.com/doda2025-team4/model-service/pull/7).
    - This was harder than anticipated, but it is now implemented for all repos except operation.
   
- Noky:
  - I have worked on [PR50](https://github.com/doda2025-team4/operation/pull/50) to implement some builtin in modules instead of using i.e. a kubectl command

### Week Q2.7 (Jan 5+) 
- Joshua:
  - In `operation`: [PR 58](https://github.com/doda2025-team4/operation/pull/58).
  - I have made final updates to A2 mostly relating to the package versions of steps 9 and 10
  - In `operation`: [PR 59](https://github.com/doda2025-team4/operation/pull/59).
  - I have addeed additional documentation regarding sticky sessions and verifications to match previous weeks

- Poyraz:
  - Changed the rate limiting to per user based on header id. Also looked into other ways of doing it but I could only think of doing it based on JWT auth which I dont know if it is in the scope of the assignment. It might be better to get clarification on what needs to be done in order to get the per user requirement. [PR 64](https://github.com/doda2025-team4/operation/pull/64).

- Andrea:
  - I have worked on two first drafts for the proposed extension in [PR 67](https://github.com/doda2025-team4/operation/pull/67)

 - Kasper":
  - I have expanded the canary version and created the canary branches for the app and model-service: [PR 14](https://github.com/doda2025-team4/app/pull/14) and [PR 8](https://github.com/doda2025-team4/model-service/pull/8)

- Noky:
  - I investigated an issue that initially lead to an issue parsing one of the YAML files for the istio virtual service, this turned out to be something bigger regarding the installation of the app on the vagrant cluster and our instructions to do so. This is all fixed i;n [PR66](https://github.com/doda2025-team4/operation/pull/66)

### Week Q2.8 (Jan 12+)
- Poyraz:
  - Fixed hosts to "ctrl" in finalization.yaml and added documentation regarding rate limiting. [PR 70](https://github.com/doda2025-team4/operation/pull/70)

- Andrea:
  - I have worked on fixing some errors and adding the missing features needed for the excellent implementation of the Sticky Session in [PR 69](https://github.com/doda2025-team4/operation/pull/69)
 
 - Kasper:
  - I have fixed a deployment reproducibility bug: [PR 65](https://github.com/doda2025-team4/operation/pull/65)

- Noky:
  - This week was a bit busy for me, so I worked on extending the functionality that I added in [PR50](https://github.com/doda2025-team4/operation/pull/50), since that was not merged yet.

- Mohammed:
  - Fixed inventory.cfg to use VM IPs instead of localhost addresses for proper Ansible provisioning. [PR 48](https://github.com/doda2025-team4/operation/pull/48)

### Week Q2.9 (Jan 19+)
- Kasper:
  - I have implemented working email alerts using the Prometheus Alertmanager in `operation`: [PR 74](https://github.com/doda2025-team4/operation/pull/74).

- Poyraz:
  - I have worked on the deployment.md file which is a seperate document with high level details and no assignment specific testing or verification content. [PR 77](https://github.com/doda2025-team4/operation/pull/77).

- Andrea:
  - I have worked on writing the final extension proposal for A4 in [PR 79](https://github.com/doda2025-team4/operation/pull/79)

- Mohammed:
  - Removed hardcoded SMTP password from Helm chart and updated README with manual secret creation instructions for A3 in [PR 80](https://github.com/doda2025-team4/operation/pull/80).
 
### Week Q2.10 (Jan 26+)
- Mohammed:
  - I added Mermaid diagrams to docs/deployment.md for A4 visualization in [PR 81](https://github.com/doda2025-team4/operation/pull/81).
