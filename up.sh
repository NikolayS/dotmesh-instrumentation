#!/bin/bash

PASSWORD=$1
if [ "$PASSWORD" == "" ]; then
	echo "Please specify a password as the first argument."
	exit 1
fi

ETCD=datamesh-etcd
if [ "$ETCD" == "" ]; then
	echo "Please specify IP of a datamesh cluster node as the second argument."
	exit 1
fi

./down.sh

(cd docker-elk && docker-compose up -d)
(cd docker-zipkin && docker-compose up -d)
(cd etcd-browser && docker build -t etcd-browser . && \
	docker run --restart=always -d -v $HOME:/root \
        --link datamesh-etcd:datamesh-etcd \
		--name etcd-browser -p 0.0.0.0:8000:8000 \
		--env ETCD_HOST=$ETCD -e ETCD_PORT=42379 \
		-e ETCDCTL_CA_FILE=/root/.datamesh/pki/ca.pem \
		-e ETCDCTL_KEY_FILE=/root/.datamesh/pki/apiserver-key.pem \
		-e ETCDCTL_CERT_FILE=/root/.datamesh/pki/apiserver.pem \
		-t -i etcd-browser)

HTPASSWD=$(docker run --rm -ti --entrypoint htpasswd crosbymichael/htpasswd -nb admin $PASSWORD)

# Ports:
# - registry 80
# - etcd-browser 8000 => 81
# - zipkin 9411 => 82
# - kibana 5601 => 83
# - etcd-browser-local 8001 => 84

ARGS1="-e FORWARD_PORT=8000 --link etcd-browser:web       -p 81:80 --name auth-etcd-browser"
ARGS2="-e FORWARD_PORT=9411 --link zipkin:web             -p 82:80 --name auth-zipkin"
ARGS3="-e FORWARD_PORT=5601 --link kibana:web             -p 83:80 --name auth-kibana"
#ARGS4="-e FORWARD_PORT=8001 --link etcd-browser-local:web -p 84:80 --name auth-etcd-browser-local"

docker run --restart=always -d -e HTPASSWD="$HTPASSWD" $ARGS1 beevelop/nginx-basic-auth
docker run --restart=always -d -e HTPASSWD="$HTPASSWD" $ARGS2 beevelop/nginx-basic-auth
docker run --restart=always -d -e HTPASSWD="$HTPASSWD" $ARGS3 beevelop/nginx-basic-auth
#docker run --restart=always -d -e HTPASSWD="$HTPASSWD" $ARGS4 beevelop/nginx-basic-auth

#docker run --restart=always -d -p 80:5000 -v /registry:/var/lib/registry --name registry registry:2
