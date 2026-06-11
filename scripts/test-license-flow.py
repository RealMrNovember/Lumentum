#!/usr/bin/env python3
"""Test Lumentum <-> license.cicibyte.com integration."""
import json
import sqlite3
import sys

import httpx

LICENSE_URL = "https://license.cicibyte.com"
API_KEY = "Cicibyte_X92kLpQ84mNz_2026!"
LUMENTUM_API = "http://127.0.0.1:18765"
EMAIL = "mozkarci1991@gmail.com"


def test_license_post(path: str, body: dict) -> None:
    url = f"{LICENSE_URL}{path}"
    print(f"\n== POST {url}")
    with httpx.Client(follow_redirects=True, timeout=20) as client:
        r = client.post(
            url,
            json=body,
            headers={"X-Api-Key": API_KEY, "Content-Type": "application/json"},
        )
        print("status", r.status_code)
        print("history", [f"{h.status_code} {h.url}" for h in r.history])
        print("body", r.text[:400])


def test_lumentum_login() -> None:
    print(f"\n== POST {LUMENTUM_API}/api/auth/login")
    with httpx.Client(timeout=20) as client:
        r = client.post(
            f"{LUMENTUM_API}/api/auth/login",
            json={"email": EMAIL, "password": "Alfa2020+*", "platform": "web"},
            headers={"Content-Type": "application/json"},
        )
        print("status", r.status_code)
        print("body", r.text[:500])


def show_lumentum_user() -> None:
    db = "/www/wwwroot/lumentum.cicibyte.com/data/lumentum.db"
    try:
        conn = sqlite3.connect(db)
        rows = conn.execute(
            "SELECT email, license_status, device_hwid FROM users WHERE email LIKE ?",
            (f"%mozkarci%",),
        ).fetchall()
        print("\n== Lumentum users", rows)
    except Exception as exc:
        print("sqlite error", exc)


if __name__ == "__main__":
    show_lumentum_user()
    test_license_post(
        "/api/v1/license/check",
        {
            "app_code": "lumentum",
            "hwid": "web-test-12345678",
            "email": EMAIL,
            "platform": "web",
        },
    )
    if len(sys.argv) > 1 and sys.argv[1] == "--login":
        test_lumentum_login()
