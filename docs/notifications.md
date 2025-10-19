---
title: Notification template reference
sort_rank: 7
---

* notifications workflow
  * Prometheus creates & sends alerts -- to the -- Alertmanager
  * 👀Alertmanager sends notifications out -- , based on their labels, to -- DIFFERENT receivers👀 

* receiver 
  * built-in integrations
    * Slack,
    * PagerDuty,
    * email,
    * ...
    * custom integration -- via the -- generic webhook interface

* Alertmanager's notification templates
  * 👀-- based on -- [Go templating](http://golang.org/pkg/text/template) system👀 /
    * ways to evaluated fields
      * -- as -- text
      * -- as -- HTML
  * uses
    * send notifications -- to -- receivers
  * types
    * default
    * custom
  * ⚠️!= [Prometheus templating language](https://prometheus.io/docs/visualization/template_reference/)⚠️

# Data Structures

## Data -- `Data` -- 

* `Data`
  * == structure /
    * passed -- to -- notification templates & webhook pushes

| Name              | Type            | Notes                                                                                             |
|-------------------|-----------------|---------------------------------------------------------------------------------------------------|
| Receiver          | string          | == receiver's name \| notification will be sent to (slack, email etc.)                            |
| Status            | string          | ALLOWED values <br/> &nbsp;&nbsp; if >=1 alert is firing -> firing <br/> &nbsp;&nbsp; resolved    |
| Alerts            | [Alert](#alert) | ALL alert objects \| this group                                                                   |
| GroupLabels       | [KV](#kv)       | == labels / group the alerts                                                                      | 
| CommonLabels      | [KV](#kv)       | == labels / COMMON \| ALL alerts                                                                  |
| CommonAnnotations | [KV](#kv)       | == annotations / COMMON \| ALL alerts <br/> uses <br/> &nbsp;&nbsp; ADDITIONAL alert's information |
| ExternalURL       | string          | == Alertmanager's backlink / sent the notification                                                |

* `Alerts` type
  * exposes functions / filter alerts
    - `Alerts.Firing`
      - 's return
        - list of currently FIRING alert objects | this group
    - `Alerts.Resolved`
      - 's return
        - list of RESOLVED alert objects | this group

## Alert

* `Alert`
  * == 👀1 alert | notification templates👀

| Name         | Type       | Notes                                                                                                                            |
|--------------|------------|----------------------------------------------------------------------------------------------------------------------------------|
| Status       | string     | ALLOWED values <br/> &nbsp;&nbsp; if >=1 alert is firing -> firing <br/> &nbsp;&nbsp; resolved                                   |
| Labels       | [KV](#kv)  | == labels / attached \| alert                                                                                                    |
| Annotations  | [KV](#kv)  | == alert's annotations                                                                                                           |
| StartsAt     | time.Time  | == time \| alert started firing <br/> if omitted -> current time is assigned -- by the -- Alertmanager                           |
| EndsAt       | time.Time  | == if the end time of an alert is known -> set <br/> Otherwise == configurable timeout period -- from -- last alert was received |
| GeneratorURL | string     | == backlink -- to the -- entity / caused this alert                                                                              |
| Fingerprint  | string     | Fingerprint / used -- to identify the -- alert                                                                                   |

## KV

* == key/value string pairs /
  * uses
    * represent labels & annotations
  * syntax

    ```
    type KV map[string]string
    ```

Annotation example containing two annotations:

```
{
  summary: "alert summary",
  description: "alert description",
}
```

In addition to direct access of data (labels and annotations) stored as KV, 
there are also methods for sorting, removing, and viewing the LabelSets:

### KV methods
| Name          | Arguments     | Returns  | Notes    |
| ------------- | ------------- | -------- | -------- |
| SortedPairs | - | Pairs (list of key/value string pairs.) | Returns a sorted list of key/value pairs. |
| Remove | []string | KV | Returns a copy of the key/value map without the given keys. |
| Names | - | []string | Returns the names of the label names in the LabelSet. |
| Values | - | []string | Returns a list of the values in the LabelSet. |

# Functions

* [Go templating's default functions](http://golang.org/pkg/text/template/#hdr-Functions) 

## Strings

| Name             | Arguments                  | Returns                                                                                                                                                                                                                                                           | Notes    |
|------------------|----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| -------- |
| title            | string                     | [strings.Title](http://golang.org/pkg/strings/#Title), capitalises first character of each word.                                                                                                                                                                  |
| toUpper          | string                     | [strings.ToUpper](http://golang.org/pkg/strings/#ToUpper), converts all characters to upper case.                                                                                                                                                                 |
| toLower          | string                     | [strings.ToLower](http://golang.org/pkg/strings/#ToLower), converts all characters to lower case.                                                                                                                                                                 |
| trimSpace        | string                     | [strings.TrimSpace](https://pkg.go.dev/strings#TrimSpace), removes leading and trailing white spaces.                                                                                                                                                             |
| match            | pattern, string            | [Regexp.MatchString](https://golang.org/pkg/regexp/#MatchString). Match a string using Regexp.                                                                                                                                                                    |
| reReplaceAll     | pattern, replacement, text | [Regexp.ReplaceAllString](http://golang.org/pkg/regexp/#Regexp.ReplaceAllString) Regexp substitution, unanchored.                                                                                                                                                 |
| join             | sep string, s []string     | [strings.Join](http://golang.org/pkg/strings/#Join), concatenates the elements of s to create a single string. The separator string sep is placed between elements in the resulting string. (note: argument order inverted for easier pipelining in templates.)   |
| safeHtml         | text string                | [html/template.HTML](https://golang.org/pkg/html/template/#HTML), Marks string as HTML not requiring auto-escaping.                                                                                                                                               |
| stringSlice      | ...string                  | Returns the passed strings as a slice of strings.                                                                                                                                                                                                                 |
| date             | string, time.Time          | Returns the text representation of the time in the specified format. For documentation on formats refer to [pkg.go.dev/time](https://pkg.go.dev/time#pkg-constants).                                                                                              |
| tz               | string, time.Time          | Returns the time in the timezone. For example, Europe/Paris.                                                                                                                                                                                                      |
| since            | time.Time                  | [time.Duration](https://pkg.go.dev/time#Since), returns the duration of how much time passed from the provided time till the current system time.                                                                                                                 |
| humanizeDuration | number or string           | Returns a human-readable string representing the duration, and the error if it happened.                                                                                                                                                                          |
