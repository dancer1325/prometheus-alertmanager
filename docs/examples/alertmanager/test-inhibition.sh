#!/bin/bash

echo "=== TESTING INHIBITION ==="
echo

# Function to send alerts to Alertmanager API
send_alert() {
    local alert_data="$1"
    local description="$2"
    
    echo "Sending: $description"
    curl -s -XPOST http://localhost:9093/api/v2/alerts \
         -H "Content-Type: application/json" \
         -d "$alert_data"
    echo
}

# Test 1: instance alerts (ALL are notified)
echo "--- Test 1: Only instance alerts (NO inhibition) ---"
send_alert '[
  {"labels": {"alertname": "InstanceDown", "instance": "server1", "cluster": "prod-web"}},
  {"labels": {"alertname": "InstanceDown", "instance": "server2", "cluster": "prod-web"}}
]' "2 InstanceDown alerts"

echo "Waiting 10s to see notifications..."
sleep 10

# Test 2: Cluster down + Instance down (Instance should be inhibited)
echo "--- Test 2: ClusterDown inhibits InstanceDown with cluster=prod-web, BUT NOT others ---"
send_alert '[
  {"labels": {"alertname": "ClusterDown", "cluster": "prod-web"}},
  {"labels": {"alertname": "InstanceDown", "instance": "server1", "cluster": "prod-web"}},
  {"labels": {"alertname": "InstanceDown", "instance": "server2", "cluster": "prod-web"}},
  {"labels": {"alertname": "InstanceDown", "instance": "server2", "cluster": "prod-desktop"}}
]' "ClusterDown + 2 InstanceDown (same cluster)"

echo "Waiting 10s to see inhibition..."
sleep 10

# Test 3: Datacenter outage inhibits everything
echo "--- Test 3: DatacenterOutage inhibits ClusterDown and InstanceDown ---"
send_alert '[
  {"labels": {"alertname": "DatacenterOutage", "datacenter": "us-east-1"}},
  {"labels": {"alertname": "ClusterDown", "cluster": "prod-web", "datacenter": "us-east-1"}},
  {"labels": {"alertname": "InstanceDown", "instance": "server1", "cluster": "prod-web", "datacenter": "us-east-1"}},
  {"labels": {"alertname": "ServiceDown", "service": "api", "datacenter": "us-east-1"}}
]' "DatacenterOutage + multiple alerts (same datacenter)"

echo "Waiting 10s to see total inhibition..."
sleep 10

echo "=== END OF TESTS ==="
echo
echo "Expected results:"
echo "- Test 1: 2 notifications (no inhibition)"
echo "- Test 2: 1 notification (ClusterDown, InstanceDown inhibited / cluster=prod-web, InstanceDown / cluster!=prod-web)"
echo "- Test 3: 1 notification (DatacenterOutage only, all others inhibited)"
echo
echo "Check webhook output to verify inhibition is working!"