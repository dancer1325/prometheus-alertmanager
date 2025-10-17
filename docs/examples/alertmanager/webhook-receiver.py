#!/usr/bin/env python3
from http.server import HTTPServer, BaseHTTPRequestHandler
import json

class WebhookHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        data = json.loads(post_data.decode('utf-8'))
        
        print("=== GROUPED NOTIFICATION ===")
        print(f"Alerts in group: {len(data['alerts'])}")
        print(f"Group key: {data['groupKey']}")
        print(f"Status: {data['status']}")
        
        for i, alert in enumerate(data['alerts'], 1):
            print(f"\nAlert {i}:")
            print(f"  Name: {alert['labels']['alertname']}")
            print(f"  Instance: {alert['labels'].get('instance', 'N/A')}")
            print(f"  Service: {alert['labels'].get('service', 'N/A')}")
            print(f"  Cluster: {alert['labels'].get('cluster', 'N/A')}")
        
        print("=" * 30)
        
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'OK')

if __name__ == '__main__':
    server = HTTPServer(('127.0.0.1', 5001), WebhookHandler)
    print("Webhook server running on http://127.0.0.1:5001")
    server.serve_forever()