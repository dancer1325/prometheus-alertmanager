* goal
  * Alertmanager

# Requirements
* [install](/prometheus-alertmanager/README.md#install)
* run Alertmanager locally
  * | this path
      * `alertmanager --config.file=promAlertManager.yml`
  * | browser,
      * http://localhost:9093/

# | runtime, reload its configuration
* | [alertmanager.yml](alertmanager.yml),
  * change something

## ways
### `kill -SIGHUP PROMETHEUS_ALERTMANAGER_PID`
* | RANDOM path,
  * `ps aux | grep alertmanager`
  * `kill -SIGHUP PREVIOUS_PID_GOT`

### hit `/-/reload` endpoint
* `curl -X POST http://localhost:9093/-/reload`

## if it's NOT well-formed -> changes NOT applied & error is logged
* | [alertmanager.yml](alertmanager.yml),
  * change something
* trigger SOME PREVIOUS ways
  * display error | console
