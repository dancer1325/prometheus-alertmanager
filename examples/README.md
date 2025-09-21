* goal
  * run Alertmanager locally
  * run amtool locally
  * TODO:

# Requirements
* [install](/prometheus-alertmanager/README.md#install)

# how to run Alertmanager locally?
* | this path
  * `alertmanager --config.file=promAlertManager.yml`
* | browser,
  * http://localhost:9093/

# handle deduplication
* `alertmanager --config.file=promAlertManager.yml`
* `chmod +x test_deduplication.sh`
  * give rights
* `./test_deduplication.sh`
* | browser,
  * http://localhost:9093/#/alerts
    * check there is 1! alert

# handle grouping

# amtool
* requirements
  * [install it](/prometheus-alertmanager/README.md)
  * run Alertmanager

## run commands
* | any terminal,
  * alerts
    * query
      * `amtool alert --alertmanager.url=http://localhost:9093`
        * 's return
          * ALL active alerts configured
      * `amtool -o extended alert --alertmanager.url=http://localhost:9093`
        * 's return
          * ALL active alerts / extended characteristics
      * `amtool -o extended alert query alertname="Test_Alert" --alertmanager.url=http://localhost:9093`
        * 's return
          * ALL active alerts / filter in
        * TODO: add previous alert / matches
  * silences
    * add
      * `amtool silence add alertname=Test_Alert --comment="Maintenance window" --alertmanager.url=http://localhost:9093`
        * add a silence
        * 's return
          * silenceId
    * query
      * `amtool silence query --alertmanager.url=http://localhost:9093`
        * 's return
          * ALL silences
      * `amtool silence query alertname=Test_Alert --alertmanager.url=http://localhost:9093`
    * expire
      * `amtool silence expire <expireIdToAdd> --alertmanager.url=http://localhost:9093`
        * expire the silences
      * `amtool silence expire $(amtool silence query -q queryToFilter)`
        * `amtool silence expire $(amtool silence query -q instance=~".+0")`

* TODO: 
  * Try out how a template works
* Let's say you have this in your configuration file:
```
templates:
  - '/foo/bar/*.tmpl'
```

Then you can test out how a template would look like with example by using this command:
```
amtool template render --template.glob='/foo/bar/*.tmpl' --template.text='{{ template "slack.default.markdown.v1" . }}'
```

## COMMON configurations
* steps
  * `mkdir -p $HOME/.config/amtool`
  * `echo 'alertmanager.url: "http://localhost:9093"' > $HOME/.config/amtool/config.yml`
  * `amtool alert`
    * NO need to specify `--alertmanager.url=http://localhost:9093`

## routes of your configuration
* steps
  * `amtool config routes --alertmanager.url=http://localhost:9093`
    * 's return
      * routing tree == [alertManager](promAlertManager.yml)'s `route.routes`
  * `amtool config routes --alertmanager.url=http://localhost:9093`
