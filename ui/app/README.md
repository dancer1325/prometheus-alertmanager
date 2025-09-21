# Alertmanager UI

* == Alertmanager UI's re-write 
  * | [elm-lang](http://elm-lang.org/)

## Usage

### Filtering | alerts page

* alert
  * 's status
    * ALLOWED ones
      * active
        * by default
      * silenced
        * ?silenced=true
      * inhibited
        * ?inhibited=true
      * muted
        * ?muted=true
  * 's receivers
    * ALLOWED ones
      * those ones / configured | Alertmanager's yaml configuration file
    * ?receiver=ReceiverConfiguredName
  * filtering
    * -- based on -- label matchers
    * ?filter=%7Bseverity%3D%22warning%22
      * URL encoded

### Filtering | silences page

Filtering based on label matchers is available
They can easily be added and modified through the UI.

```
http://alertmanager/#/silences?filter=%7Bseverity%3D%22warning%22%2C%20owner%3D%22backend%22%7D
```

### Filtering -- via -- label matchers

Filtering via label matchers follows the same syntax and semantics as Prometheus.

A properly formatted filter is a set of label matchers joined by accepted
matching operators, surrounded by curly braces:

```
{foo="bar", baz=~"quu.*"}
```

Operators include:

- `=`
- `!=`
- `=~`
- `!~`

See the official documentation for additional information: https://prometheus.io/docs/querying/basics/#instant-vector-selectors
