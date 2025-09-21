---
title: Alerting overview
sort_rank: 1
nav_icon: sliders
---

* Alerting with Prometheus
  * == 
    * Alerting rules | Prometheus servers
      * send alerts -- to an -- Alertmanager 
    * [Alertmanager](alertmanager.md)
      * manages alerts + silencing + inhibition + aggregation
      * send out notifications -- via -- email + on-call notification systems + chat platforms

* steps to set up alerting & notifications
  * Setup & [configure](configuration.md) the Alertmanager
  * [Configure Prometheus](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#alertmanager_config) / talk -- to the -- Alertmanager
  * Create [alerting rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) | Prometheus
