#!/bin/bash

(cd docker-elk && docker-compose down)
(cd docker-zipkin && docker-compose down)

docker rm -f etcd-browser
docker rm -f auth-etcd-browser auth-zipkin auth-kibana
