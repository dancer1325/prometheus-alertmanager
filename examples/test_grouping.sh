#!/bin/bash

# Script para probar diferentes estrategias de grouping
ALERTMANAGER_URL="http://localhost:9093"

echo "Enviando alertas para probar grouping por severity y service..."

# Grupo 1: Alertas críticas del servicio web
curl -XPOST $ALERTMANAGER_URL/api/v2/alerts -H "Content-Type: application/json" -d '[
  {
    "labels": {
      "alertname": "HighCPU",
      "service": "web",
      "severity": "critical",
      "instance": "web-1"
    },
    "annotations": {
      "summary": "High CPU on web-1"
    }
  }
]'

sleep 1

curl -XPOST $ALERTMANAGER_URL/api/v2/alerts -H "Content-Type: application/json" -d '[
  {
    "labels": {
      "alertname": "HighMemory", 
      "service": "web",
      "severity": "critical",
      "instance": "web-2"
    },
    "annotations": {
      "summary": "High Memory on web-2"
    }
  }
]'

sleep 1

# Grupo 2: Alertas warning del servicio database
curl -XPOST $ALERTMANAGER_URL/api/v2/alerts -H "Content-Type: application/json" -d '[
  {
    "labels": {
      "alertname": "SlowQuery",
      "service": "database",
      "severity": "warning", 
      "instance": "db-1"
    },
    "annotations": {
      "summary": "Slow queries on db-1"
    }
  }
]'

sleep 1

curl -XPOST $ALERTMANAGER_URL/api/v2/alerts -H "Content-Type: application/json" -d '[
  {
    "labels": {
      "alertname": "HighConnections",
      "service": "database", 
      "severity": "warning",
      "instance": "db-2"
    },
    "annotations": {
      "summary": "High connections on db-2"
    }
  }
]'

echo "✅ Alertas enviadas. Las alertas se agruparán por [service, severity]"
echo "Verifica en http://localhost:9093 - deberías ver 2 grupos:"
echo "  - Grupo 1: web + critical (2 alertas)"
echo "  - Grupo 2: database + warning (2 alertas)"