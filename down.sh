#!/bin/bash

(cd docker-elk && docker-compose down)
(cd docker-zipkin && docker-compose down)

docker rm -f etcd-browser etcd-browser-local
docker rm -f auth-etcd-browser auth-zipkin auth-kibana auth-etcd-browser-local
docker rm -f registry
