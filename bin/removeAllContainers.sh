#!/usr/bin/env bash

docker container stop compute000 compute001 head-node
docker container rm compute000 compute001 head-node