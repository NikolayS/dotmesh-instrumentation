#!/usr/bin/env bash

./down.sh
docker run --restart=always -d -p 80:5000 -v /registry:/var/lib/registry --name registry registry:2
