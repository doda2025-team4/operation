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

## Features Overview

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

