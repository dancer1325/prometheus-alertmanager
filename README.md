# Alertmanager

* Alertmanager
  * responsible for
    * handling alerts / sent -- by -- client applications (_Example:_ Prometheus server)
      * handle ==
        * deduplicating
          * == remove duplicated alerts
          * Reason:🧠avoid processing >1 SAME alert🧠
        * grouping,
          * == combine MULTIPLE alerts | 1! group
          * Reason:🧠
            * avoid duplicate alerts
            * make easier the management🧠
        * routing them -- to the -- correct [receiver integrations](https://prometheus.io/docs/alerting/latest/configuration/#receiver)
          * _Example:_ email, PagerDuty, OpsGenie, OR [OTHERS](https://prometheus.io/docs/operating/integrations/#alertmanager-webhook-receiver)
        * silence
        * inhibit

* [Documentation](docs)

## Install

* ways  
  * [Precompiled binaries](#precompiled-binaries)
  * [docker](#docker-images)
  * [compile the binary](#compiling-the-binary)

### Precompiled binaries

* steps
  * download your proper [release](https://github.com/prometheus/alertmanager/releases)
  * install it

### Docker images

* hosted |
  * [Quay.io](https://quay.io/repository/prometheus/alertmanager)
  * [Docker Hub](https://hub.docker.com/r/prom/alertmanager/)

* steps
  * | any terminal,
    * `docker run --name alertmanager -d -p 127.0.0.1:9093:9093 quay.io/prometheus/alertmanager`
  * | browser,
    * http://localhost:9093/

### Compiling the binary

* ways
  * [get remotely](#get-remotely-)
  * [build manually](#build-manually)

#### get remotely 

* steps
  * | this terminal
    * `GO15VENDOREXPERIMENT=1 go get github.com/prometheus/alertmanager/cmd/...`
      * Problems:
        * Problem1: NOT installed
          * Solution: `go install github.com/prometheus/alertmanager/cmd/alertmanager@latest`
  * | [here](examples)
    * `alertmanager --config.file=promAlertManager.yml`
  * | browser,
    * http://localhost:9093/

#### build manually

* | this path,
  * `make build`
    * if you ONLY want to build 1! binary -> `make build BINARIES=YourDesiredBinary` 
      * _Example:_ `make build BINARIES=amtool`
  * `./alertmanager --config.file=examples/promAlertManager.yml`

## API

* CURRENT Alertmanager API
  * v1
    * | `0.16.0`,
      * deprecated
    * | `0.27.0`,
      * removed 
  * v2
    * generated -- via -- 
      * [OpenAPI project](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md) + [Go Swagger](https://github.com/go-swagger/go-swagger/)
    * [API specification](api/v2/openapi.yaml)
    * hosted [here](http://petstore.swagger.io/?url=https://raw.githubusercontent.com/prometheus/alertmanager/main/api/v2/openapi.yaml)
    * `/api/v2`
      * ⚠️host path⚠️
    * if you set `--web.route-prefix` -> prefix | host path
      * _Example:_ `--web.route-prefix=/alertmanager/` -> `/alertmanager/api/v2/status`

## amtool

* `amtool`
  * == CL /
    * allows
      * 👀interacting -- with the -- Alertmanager API👀
    * bundled with ALL Alertmanager releases

### Install

```
$ go install github.com/prometheus/alertmanager/cmd/amtool@latest
```

* _Examples:_ [here](examples/README.md#run-commands)

### Configuration

* `amtool`'s
  * configuration file
    * == .yml / 
      * set COMMON configurations
        * _Example:_ [here](examples/README.md#common-configurations)
    * 👀default paths👀
      * `$HOME/.config/amtool/config.yml`
      * `/etc/amtool/config.yml`

### Routes of your configuration

* allows
  * visualize alertManager routing tree
    * == AlertManager configuration `route.routes`
  * test the routing by passing it label set of an alert
    and it prints out all receivers the alert would match ordered and separated by `,`.
    (If you use `--verify.receivers` amtool returns error code 1 on mismatch)

Example of usage:
```
# Test if alert matches expected receiver
test 
    --config.file=doc/examples/simple.yml
     --tree
      --verify.receivers=team-X-pager
       service=database owner=team-X
```

## High Availability

Alertmanager's high availability is in production use at many companies and is enabled by default.

> Important: Both UDP and TCP are needed in alertmanager 0.15 and higher for the cluster to work.
>  - If you are using a firewall, make sure to whitelist the clustering port for both protocols.
>  - If you are running in a container, make sure to expose the clustering port for both protocols.

To create a highly available cluster of the Alertmanager the instances need to
be configured to communicate with each other. This is configured using the
`--cluster.*` flags.

- `--cluster.listen-address` string: cluster listen address (default "0.0.0.0:9094"; empty string disables HA mode)
- `--cluster.advertise-address` string: cluster advertise address
- `--cluster.peer` value: initial peers (repeat flag for each additional peer)
- `--cluster.peer-timeout` value: peer timeout period (default "15s")
- `--cluster.gossip-interval` value: cluster message propagation speed
  (default "200ms")
- `--cluster.pushpull-interval` value: lower values will increase
  convergence speeds at expense of bandwidth (default "1m0s")
- `--cluster.settle-timeout` value: maximum time to wait for cluster
  connections to settle before evaluating notifications.
- `--cluster.tcp-timeout` value: timeout value for tcp connections, reads and writes (default "10s")
- `--cluster.probe-timeout` value: time to wait for ack before marking node unhealthy
  (default "500ms")
- `--cluster.probe-interval` value: interval between random node probes (default "1s")
- `--cluster.reconnect-interval` value: interval between attempting to reconnect to lost peers (default "10s")
- `--cluster.reconnect-timeout` value: length of time to attempt to reconnect to a lost peer (default: "6h0m0s")
- `--cluster.label` value: the label is an optional string to include on each packet and stream. It uniquely identifies the cluster and prevents cross-communication issues when sending gossip messages (default:"")

The chosen port in the `cluster.listen-address` flag is the port that needs to be
specified in the `cluster.peer` flag of the other peers.

The `cluster.advertise-address` flag is required if the instance doesn't have
an IP address that is part of [RFC 6890](https://tools.ietf.org/html/rfc6890)
with a default route.

To start a cluster of three peers on your local machine use [`goreman`](https://github.com/mattn/goreman) and the
Procfile within this repository.

	goreman start

To point your Prometheus 1.4, or later, instance to multiple Alertmanagers, configure them
in your `prometheus.yml` configuration file, for example:

```yaml
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - alertmanager1:9093
      - alertmanager2:9093
      - alertmanager3:9093
```

> Important: Do not load balance traffic between Prometheus and its Alertmanagers, but instead point Prometheus to a list of all Alertmanagers
* The Alertmanager implementation expects all alerts to be sent to all Alertmanagers to ensure high availability.

### Turn off high availability

If running Alertmanager in high availability mode is not desired, setting `--cluster.listen-address=` prevents Alertmanager from listening to incoming peer requests.

## Architecture

![](doc/arch.svg)
