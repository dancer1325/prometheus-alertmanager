* goal
  * Alertmanager's UI

# Requirements
* [install](/prometheus-alertmanager/README.md#install)
* `alertmanager --config.file=alertmanager-simple.yml`

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

# Filtering | silences page

# Filtering -- via -- label matchers


