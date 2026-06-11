import logging
from dataclasses import dataclass

import httpx

from app.config import settings

logger = logging.getLogger(__name__)


@dataclass
class LicenseResult:
    status: str
    plan_tier: str
    expires_at: str | None = None
    license_key: str | None = None

    @property
    def is_usable(self) -> bool:
        return self.status == "active"


class LicenseClient:
    """license.cicibyte.com — app_code: lumentum, 14 günlük trial."""

    def __init__(self) -> None:
        self.base_url = settings.license_api_url.rstrip("/")
        self.app_code = settings.license_product_id
        self.api_key = settings.license_api_key
        self.mock = settings.license_mock

    def _headers(self) -> dict[str, str]:
        headers = {"Content-Type": "application/json", "Accept": "application/json"}
        if self.api_key:
            headers["X-Api-Key"] = self.api_key
        return headers

    def _parse_response(self, data: dict) -> LicenseResult:
        payload = data.get("data") or {}
        return LicenseResult(
            status=str(payload.get("status", "expired")),
            plan_tier=str(payload.get("type", "trial")),
            expires_at=payload.get("expires_at"),
            license_key=payload.get("license_key"),
        )

    def start_trial(
        self,
        *,
        email: str,
        client_name: str,
        hwid: str,
        platform: str = "web",
    ) -> LicenseResult:
        if self.mock:
            logger.info("LICENSE_MOCK trial %s", email)
            return LicenseResult(status="active", plan_tier="trial")

        body = {
            "app_code": self.app_code,
            "hwid": hwid,
            "email": email.lower(),
            "client_name": client_name,
            "platform": platform,
        }
        return self._post("/api/v1/license/trial", body)

    def check(
        self,
        *,
        email: str,
        hwid: str,
        client_name: str | None = None,
        platform: str = "web",
    ) -> LicenseResult:
        if self.mock:
            return LicenseResult(status="active", plan_tier="trial")

        body = {
            "app_code": self.app_code,
            "hwid": hwid,
            "email": email.lower(),
            "client_name": client_name,
            "platform": platform,
        }
        # Cloudflare WAF blocks POST /check (405); /verify is equivalent on license server.
        return self._post("/api/v1/license/verify", body)

    def activate(
        self,
        *,
        email: str,
        license_key: str,
        hwid: str,
        client_name: str | None = None,
        platform: str = "web",
    ) -> LicenseResult:
        if self.mock:
            return LicenseResult(status="active", plan_tier="monthly")

        body = {
            "app_code": self.app_code,
            "license_key": license_key.strip().upper(),
            "hwid": hwid,
            "email": email.lower(),
            "client_name": client_name,
            "platform": platform,
        }
        return self._post("/api/v1/license/activate", body)

    def _post(self, path: str, body: dict) -> LicenseResult:
        url = f"{self.base_url}{path}"
        try:
            with httpx.Client(timeout=20.0, follow_redirects=False) as client:
                response = client.post(
                    url,
                    json=body,
                    headers=self._headers(),
                )
                data = self._read_json(response)
                if response.status_code >= 400 or not data.get("success"):
                    message = data.get("message", "Lisans sunucusu hatası")
                    logger.warning("License API %s: %s", path, message)
                    raise LicenseError(message, response.status_code)
                return self._parse_response(data)
        except LicenseError:
            raise
        except Exception as exc:
            logger.exception("License API unreachable: %s", exc)
            raise LicenseError("Lisans sunucusuna ulaşılamadı", 503) from exc

    def _read_json(self, response: httpx.Response) -> dict:
        try:
            payload = response.json()
            if isinstance(payload, dict):
                return payload
        except Exception:
            pass

        text = (response.text or "").strip()
        if "Method Not Allowed" in text or response.status_code == 405:
            raise LicenseError(
                "Lisans doğrulama uç noktasına erişilemedi (HTTP 405).",
                503,
            )
        raise LicenseError("Lisans sunucusundan geçersiz yanıt alındı", 502)


class LicenseError(Exception):
    def __init__(self, message: str, status_code: int = 400):
        self.message = message
        self.status_code = status_code
        super().__init__(message)


license_client = LicenseClient()
