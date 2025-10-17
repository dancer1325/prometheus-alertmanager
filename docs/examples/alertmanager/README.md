* goal
  * Alertmanager

# Requirements
* [install](/prometheus-alertmanager/README.md#install)

# Grouping
* [example architecture](architecture.png)
* `python3 webhook-receiver.py`
* | [docker-compose.yml](docker-compose.yml)
  * comment OR uncomment the selected feature / check
* `docker compose up -d`
## 💡alerts' SIMILAR nature -> fire 1! notification💡 / ALL information is displayed
* hit [sample.http](sample.http)'s  POST
  * see python server's logs
## way to configure | alertmanager's configuration file
* [here](alertmanager-grouping-demo.yml)'s `route.group_by`

# Inhibition
## if OTHER alerts are ALREADY fired -> suppress notifications / certain alerts
* `sh test-inhibition.sh`
## way to configure | alertmanager's configuration file
* [here](alertmanager-inhibition-demo.yml)'s `route.inhibit_rules`

# Silences
* TODO:

# Client Behavior
* TODO:

# High Availability
* TODO:
