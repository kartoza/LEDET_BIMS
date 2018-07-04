#!/usr/bin/env bash
IMAGE_NAME=limpopobims_nginx
TAG_NAME=latest
docker build --no-cache -t dimasciput/${IMAGE_NAME} .
docker tag dimasciput/${IMAGE_NAME}:latest dimasciput/${IMAGE_NAME}:${TAG_NAME}
docker push dimasciput/${IMAGE_NAME}:${TAG_NAME}