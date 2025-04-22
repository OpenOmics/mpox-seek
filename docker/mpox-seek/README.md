## Steps for Building Docker Images

Directly below are instructions for building an image using the provided Dockerfile:

```bash
# See listing of images on computer
docker image ls

# Build from Dockerfile
ln -f ../../workflow/envs/mpox.yaml .
docker buildx build --platform linux/amd64 --no-cache -f Dockerfile --tag=mpox-seek:v0.3.0 .

# Testing, take a peek inside
docker run --platform linux/amd64 -ti mpox-seek:v0.3.0 /bin/bash

# Updating Tag  before pushing to DockerHub
docker tag mpox-seek:v0.3.0 skchronicles/mpox-seek:v0.3.0
docker tag mpox-seek:v0.3.0 skchronicles/mpox-seek         # latest

# Check out new tag(s)
docker image ls

# Push new tagged image to DockerHub
docker push --platform linux/amd64 skchronicles/mpox-seek:v0.3.0
docker push --platform linux/amd64 skchronicles/mpox-seek:latest
```

### Other Recommended Steps

Scan your image for known vulnerabilities:

```bash
docker scan mpox-seek:v0.3.0
```

> **Please Note**: Any references to `skchronicles` should be replaced your username if you would also like to push the image to a non-org account.
