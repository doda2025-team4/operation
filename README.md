All repositories belonging to this project are available here:

- **app:** https://github.com/doda2025-team4/app
- **model-service:** https://github.com/doda2025-team4/model-service  
- **lib-version:** https://github.com/doda2025-team4/lib-version

Environment variables are both declared in the .env file in this repo and the dockerfiles of app and model-service repositories. If docker-compose is used, the declarations in the dockerfiles are overridden. We wanted to have this design choice to ensure that there are defaults declared in build time as well in case the container was going to be run without the docker-compose.

## Running the Application (Docker Compose)

A `docker-compose.yml` file is included to serve as the starting point for local execution of the application.  

To start the stack (once components are ready):

```bash
docker compose up

