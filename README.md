# Getting started
### Description
    This project fetches 50 latest updated projects from GitHub GraphQL API/GitLab API.
    Results are aggregated and returned.
    Each returned object consists of url, owner username, project name, project description and host.
### Pre requirements
    Install docker: https://docs.docker.com/engine/installation/
    Install Docker Compose: https://docs.docker.com/compose/install/
### Usage
    Navigate to the project
    Start development server with command: `docker-compose up`
    Example: ` GET localhost:4567/api/libraries`
    Example with parameter: ` GET localhost:4567/api/libraries?language=ruby`