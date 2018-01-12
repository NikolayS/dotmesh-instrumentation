# dotmesh-instrumentation

ELK stack, Zipkin, and etcd-ui.
All run in Docker Compose.

First, grab some creds for etcd:

```
mkdir -p ~/.dotmesh
scp -r user@cluster-node:~/.dotmesh/pki ~/.dotmesh/
```

Start the stack by running:

```
./launch.sh password ip-of-cluster-node
```

This will make available ports:

- etcd-browser => 81
- zipkin => 82
- kibana => 83

All will be vaguely protected by basic auth with username 'admin' and password 'password'.

Suitable for development use.
