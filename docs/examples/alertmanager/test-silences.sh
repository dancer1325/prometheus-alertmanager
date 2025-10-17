#!/bin/bash

echo "=== TESTING SILENCES ==="
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

# Function to create silence
create_silence() {
    local silence_data="$1"
    local description="$2"
    
    echo "Creating silence: $description"
    curl -s -XPOST http://localhost:9093/api/v2/silences \
         -H "Content-Type: application/json" \
         -d "$silence_data"
    echo
}

# Function to list active silences
list_silences() {
    echo "Active silences:"
    curl -s http://localhost:9093/api/v1/silences | jq '.data[]? | {id: .id, matchers: .matchers, comment: .comment, status: .status.state}' 2>/dev/null || echo "No silences or jq not available"
    echo
}

# Test 1: Send alerts without silence (should be notified)
echo "--- Test 1: Alerts without silence ---"
send_alert '[
  {"labels": {"alertname": "HighCPU", "instance": "server1", "service": "web"}},
  {"labels": {"alertname": "HighMemory", "instance": "server2", "service": "web"}}
]' "2 alerts without silence"

echo "Waiting 5s to see notifications..."
sleep 5

# Test 2: Create silence for specific service
echo "--- Test 2: Creating silence for service=web ---"
END_TIME=$(date -u -v+10M +%Y-%m-%dT%H:%M:%S.000Z)
create_silence '{
  "matchers": [
    {"name": "service", "value": "web", "isRegex": false}
  ],
  "startsAt": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'",
  "endsAt": "'$END_TIME'",
  "createdBy": "test-script",
  "comment": "Maintenance window for web service"
}' "Silence for service=web (10 minutes)"

list_silences

# Test 3: Send same alerts again (should be silenced -- Reason:🧠Silence for service=web🧠)
echo "--- Test 3: Same alerts with silence active ---"
send_alert '[
  {"labels": {"alertname": "HighCPU", "instance": "server1", "service": "web"}},
  {"labels": {"alertname": "HighMemory", "instance": "server2", "service": "web"}}
]' "2 alerts with active silence"

echo "Waiting 5s to see if silenced..."
sleep 5

# Test 4: Send alerts for different service (should NOT be silenced)
echo "--- Test 4: Alerts for different service (not silenced) ---"
send_alert '[
  {"labels": {"alertname": "HighCPU", "instance": "server3", "service": "database"}},
  {"labels": {"alertname": "DiskFull", "instance": "server4", "service": "cache"}}
]' "2 alerts for different services"

echo "Waiting 5s to see notifications..."
sleep 5

# Test 5: Create regex-based silence
echo "--- Test 5: Creating regex silence for instance=server.* ---"
END_TIME=$(date -u -v+5M +%Y-%m-%dT%H:%M:%S.000Z)
create_silence '{
  "matchers": [
    {"name": "instance", "value": "server.*", "isRegex": true}
  ],
  "startsAt": "'$(date -u +%Y-%m-%dT%H:%M:%S.000Z)'",
  "endsAt": "'$END_TIME'",
  "createdBy": "test-script",
  "comment": "Silence all server instances"
}' "Regex silence for instance=server.*"

list_silences

# Test 6: Send alerts matching regex (should be silenced)
echo "--- Test 6: Alerts matching regex silence ---"
send_alert '[
  {"labels": {"alertname": "NetworkDown", "instance": "server10", "service": "api"}},
  {"labels": {"alertname": "CPUHigh", "instance": "server20", "service": "frontend"}}
]' "2 alerts matching regex silence"

echo "Waiting 5s to see if silenced..."
sleep 5

echo "=== END OF TESTS ==="
echo
echo "Expected results:"
echo "- Test 1: 2 notifications (no silence)"
echo "- Test 3: 0 notifications (silenced by service=web)"
echo "- Test 4: 2 notifications (different services, not silenced)"
echo "- Test 6: 0 notifications (silenced by instance regex)"
echo
echo "Check webhook output and Alertmanager UI at http://localhost:9093/#/silences"