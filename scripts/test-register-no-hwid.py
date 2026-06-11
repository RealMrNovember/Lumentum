#!/usr/bin/env python3
import json
import urllib.error
import urllib.request

payload = json.dumps(
    {
        "email": "test-hwid-fix4@example.com",
        "password": "TestPass123",
        "first_name": "Test",
        "last_name": "User",
        "locale": "tr",
    }
).encode()

req = urllib.request.Request(
    "http://127.0.0.1:18765/api/auth/register",
    data=payload,
    headers={"Content-Type": "application/json"},
    method="POST",
)

try:
    with urllib.request.urlopen(req) as response:
        print("STATUS", response.status)
        print(response.read().decode()[:300])
except urllib.error.HTTPError as exc:
    print("STATUS", exc.code)
    print(exc.read().decode()[:500])
