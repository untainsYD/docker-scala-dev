# Scala dev env docker
- [Scala dev env docker](#scala-dev-env-docker)
    - [Build the docker](#build-the-docker)
    - [Start the docker](#start-the-docker)

## Build the docker
```sh
docker-compose up --build
```

## Start the docker
Start the docker container with `-l` option, it is needed to source bash as login shell.
```sh
docker-compose up -d
docker exec -it docker-scala-dev-scala-1 /bin/bash -l
```
