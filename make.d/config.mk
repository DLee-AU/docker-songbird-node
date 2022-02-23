# config.mk

DOCKER=/usr/bin/docker
PODMAN=/usr/bin/podman

PYTHON_IMAGE=library/python:3.9
PYTHON=${DOCKER} run ${PYTHON_IMAGE}

# DOCKER-COMPOSE=/usr/bin/docker-compose
DOCKER-COMPOSE=~/.pyenv/shims/docker-compose
# PODMAN-COMPOSE=/usr/bin/podman-compose
PODMAN-COMPOSE=~/.pyenv/shims/podman-compose


# S3 Data Locations and Service
S3_HOSTNAME="http://s3.url.example"
S3_URI="s3-bucket-example"
S3_URL=$(S3_HOSTNAME)/$(S3_URI)