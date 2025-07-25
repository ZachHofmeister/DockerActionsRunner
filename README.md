A docker container to host a github actions runner

Build Dockerfile image like:
```
docker build --tag zachhof/actions-runner:latest .
```

Test the Docker image like:
```
docker run -d --env-file .env --name runner zachhof/actions-runner:latest
```

Start using docker-compose like:
```
docker-compose up -d
```