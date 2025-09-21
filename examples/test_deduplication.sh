#!/bin/bash

# test Alertmanager's deduplication
ALERTMANAGER_URL="http://localhost:9093"

echo "send 3 IDENTICAL alerts"

# Alert 1 - FROM Prometheus-1
curl -XPOST $ALERTMANAGER_URL/api/v2/alerts -H "Content-Type: application/json" -d '[
  {
    "labels": {
      "alertname": "DatabaseDown",
      "service": "database",
      "severity": "critical",
      "instance": "db-server-1"
    },
    "annotations": {
      "summary": "Database is down",
      "description": "Database server is not responding"
    },
    "generatorURL": "http://prometheus-1:9090/graph?g0.expr=up%7Bjob%3D%22database%22%7D+%3D%3D+0"
  }
]'

sleep 2

# Alerta 2 - FROM Prometheus-2 (DUPLICATED)
curl -XPOST $ALERTMANAGER_URL/api/v2/alerts -H "Content-Type: application/json" -d '[
  {
    "labels": {
      "alertname": "DatabaseDown",
      "service": "database",
      "severity": "critical",
      "instance": "db-server-1"
    },
    "annotations": {
      "summary": "Database is down",
      "description": "Database server is not responding"
    },
    "generatorURL": "http://prometheus-2:9090/graph?g0.expr=up%7Bjob%3D%22database%22%7D+%3D%3D+0"
  }
]'

sleep 2

# Alerta 3 - FROM Prometheus-3 (DUPLICATED)
curl -XPOST $ALERTMANAGER_URL/api/v2/alerts -H "Content-Type: application/json" -d '[
  {
    "labels": {
      "alertname": "DatabaseDown",
      "service": "database",
      "severity": "critical", 
      "instance": "db-server-1"
    },
    "annotations": {
      "summary": "Database is down",
      "description": "Database server is not responding"
    },
    "generatorURL": "http://prometheus-3:9090/graph?g0.expr=up%7Bjob%3D%22database%22%7D+%3D%3D+0"
  }
]'

echo "✅ Alertas enviadas. Verifica en http://localhost:9093"