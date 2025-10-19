---
title: Management API
sort_rank: 9
---

### Health check

```
GET /-/healthy
HEAD /-/healthy
```

* 's return
  * 200 OR 500


### Readiness check

```
GET /-/ready
HEAD /-/ready
```

* 's return
  * 200 OR 500
    * == Alertmanager can serve OR NOT traffic (== respond -- to -- queries)

### Reload

```
POST /-/reload
```

* allows
  * reload the Alertmanager configuration file
* ALTERNATIVE
  * send a `SIGHUP` -- to the -- Alertmanager process
