* goal
  * Alertmanager's UI

# Requirements
* [install](/prometheus-alertmanager/README.md#install)
* `alertmanager --config.file=alertmanager-simple.yml`
* `prometheus --config.file=prometheus.yml`
* wait for 1' / alerts triggered

# Filtering | alerts page
* http://localhost:9093/#/alerts
  * filter by alert's 
    * status
      * click "Silenced", "Inhibited", "Muted"
      * see DIFFERENT URL parameters
    * receivers
      * click receiver 
        * == configured `receivers` | Alertmanager's yaml configuration file
        * see DIFFERENT URL parameters
    * label matchers
      * filter by some label -- `service: servicesecond` --

# Filtering | silences page

# Filtering -- via -- label matchers


