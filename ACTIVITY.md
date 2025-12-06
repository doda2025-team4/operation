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
  - I have worked on A3 by alerting. Currently incomplete because Prometheus is not yet integrated.

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

