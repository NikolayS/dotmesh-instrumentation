#!/bin/bash
(cd docker-elk && docker-compose up -d)
(cd docker-zipkin && docker-compose up -d)
(cd etcd-browser && docker build -t etcd-browser . && \
    docker run -d -v /home:/home \
        --name etcd-browser -p 0.0.0.0:8000:8000 \
        --net=host --env ETCD_HOST=localhost -e ETCD_PORT=42379 \
        -e ETCDCTL_CA_FILE=~/.datamesh/pki/ca.pem \
        -e ETCDCTL_KEY_FILE=~/.datamesh/pki/apiserver-key.pem \
        -e ETCDCTL_CERT_FILE=~/.datamesh/pki/apiserver.pem \
        -t -i etcd-browser)
