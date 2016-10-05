# Nomad/Consul Multi DC Vagrant Lab

Two Nomad/Consul DC using CoreOS to simulate a multi DC lab.

DC1 = 10.30.0.10x
DC2 = 10.40.0.10x

```
vagrant up
```

## Consul

Let's install consul.

Login using `vagrant ssh dc1-1` and so on for the hostnames.

### DC1

For the first DC:
```
# on dc1-1 (the bootstrap)
$ docker run -d --name consul --net=host -e 'CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}' consul:v0.7.0 agent -server -bind=10.30.0.101 -bootstrap-expect=3 -datacenter=dc1 -node=dc1-1 -client=0.0.0.0 -ui

# on dc1-2
$ docker run -d --name consul --net=host -e 'CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}' consul:v0.7.0 agent -server -bind=10.30.0.102 -retry-join=10.30.0.101 -datacenter=dc1 -node=dc1-2 -client=0.0.0.0 -ui

# on dc1-3
$ docker run -d --name consul --net=host -e 'CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}' consul:v0.7.0 agent -server -bind=10.30.0.103 -retry-join=10.30.0.101 -datacenter=dc1 -node=dc1-3 -client=0.0.0.0 -ui
```

Navigate to http://10.30.0.101:8500/ui/ and check it's ok

or

```
$ docker exec -it consul consul members
Node   Address           Status  Type    Build  Protocol  DC
dc1-1  10.30.0.101:8301  alive   server  0.7.0  2         dc1
dc1-2  10.30.0.102:8301  alive   server  0.7.0  2         dc1
dc1-3  10.30.0.103:8301  alive   server  0.7.0  2         dc1
```

### DC2

For the second DC:

```
# on dc2-1 (the bootstrap)
$ docker run -d --name consul --net=host -e 'CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}' consul:v0.7.0 agent -server -bind=10.40.0.101 -bootstrap-expect=3 -datacenter=dc2 -node=dc2-1 -client=0.0.0.0 -ui

# on dc2-2
$ docker run -d --name consul --net=host -e 'CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}' consul:v0.7.0 agent -server -bind=10.40.0.102 -retry-join=10.40.0.101 -datacenter=dc2 -node=dc2-2 -client=0.0.0.0 -ui

# on dc2-3
$ docker run -d --name consul --net=host -e 'CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}' consul:v0.7.0 agent -server -bind=10.40.0.103 -retry-join=10.40.0.101 -datacenter=dc2 -node=dc2-3 -client=0.0.0.0 -ui
```

Navigate to http://10.40.0.101:8500/ui/ and check it's ok

or

```
$ docker exec -it consul consul members
Node   Address           Status  Type    Build  Protocol  DC
dc2-1  10.40.0.101:8301  alive   server  0.7.0  2         dc2
dc2-2  10.40.0.102:8301  alive   server  0.7.0  2         dc2
dc2-3  10.40.0.103:8301  alive   server  0.7.0  2         dc2
```

### WAN

Join every DC1 nodes:

```
$ docker exec -it consul consul join -wan 10.30.0.101 10.30.0.102 10.30.0.103
Successfully joined cluster by contacting 3 nodes.

$ docker exec -it consul consul members -wan
Node       Address           Status  Type    Build  Protocol  DC
dc1-1.dc1  10.30.0.101:8302  alive   server  0.7.0  2         dc1
dc1-2.dc1  10.30.0.102:8302  alive   server  0.7.0  2         dc1
dc1-3.dc1  10.30.0.103:8302  alive   server  0.7.0  2         dc1
```

Join every DC2 nodes:

```
$ docker exec -it consul consul join -wan 10.40.0.101 10.40.0.102 10.40.0.103
Successfully joined cluster by contacting 3 nodes.

$ docker exec -it consul consul members -wan
Node       Address           Status  Type    Build  Protocol  DC
dc1-1.dc1  10.30.0.101:8302  alive   server  0.7.0  2         dc1
dc1-2.dc1  10.30.0.102:8302  alive   server  0.7.0  2         dc1
dc1-3.dc1  10.30.0.103:8302  alive   server  0.7.0  2         dc1
dc2-1.dc2  10.40.0.101:8302  alive   server  0.7.0  2         dc2
dc2-2.dc2  10.40.0.102:8302  alive   server  0.7.0  2         dc2
dc2-3.dc2  10.40.0.103:8302  alive   server  0.7.0  2         dc2
```
