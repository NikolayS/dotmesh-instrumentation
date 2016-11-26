# datamesh-instrumentation

ELK stack, Zipkin, and etcd-ui.
All run in Docker Compose.

First, grab some creds for etcd:

```
mkdir ~/.datamesh && scp user@cluster-node:~/.datamesh/pki ~/.datamesh/
```

Start the stack by running:

```
./launch.sh password
```

This will make available ports:

- etcd-browser => 81
- zipkin => 82
- kibana => 83

All will be vaguely protected by basic auth with username 'admin' and password 'password'.

Suitable for development use.
