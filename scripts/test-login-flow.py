#!/usr/bin/env python3
import json
import sys
import urllib.error
import urllib.request

LUMENTUM = "http://127.0.0.1:18765"
EMAIL = "mozkarci1991@gmail.com"
PASSWORD = sys.argv[1] if len(sys.argv) > 1 else "Alfa2020+*"


def post(path: str, payload: dict) -> tuple[int, str]:
    req = urllib.request.Request(
        f"{LUMENTUM}{path}",
        data=json.dumps(payload).encode(),
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req) as resp:
            return resp.status, resp.read().decode()[:500]
    except urllib.error.HTTPError as exc:
        return exc.code, exc.read().decode()[:500]


if __name__ == "__main__":
    code, body = post(
        "/api/auth/login",
        {"email": EMAIL, "password": PASSWORD, "platform": "web"},
    )
    print("LOGIN", code)
    print(body)
