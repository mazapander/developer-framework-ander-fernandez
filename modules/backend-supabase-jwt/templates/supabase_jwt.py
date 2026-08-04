from functools import lru_cache
from typing import Any

import jwt
from jwt import PyJWKClient


class TokenVerificationError(Exception):
    pass


class SupabaseJWTVerifier:
    def __init__(self, issuer: str, audience: str | None = None) -> None:
        self.issuer = issuer.rstrip("/")
        self.audience = audience
        self.jwks_client = PyJWKClient(
            f"{self.issuer}/.well-known/jwks.json",
            cache_jwk_set=True,
            lifespan=600,
        )

    def verify(self, token: str) -> dict[str, Any]:
        try:
            signing_key = self.jwks_client.get_signing_key_from_jwt(token)
            options = {"require": ["exp", "iss", "sub"]}
            kwargs: dict[str, Any] = {
                "key": signing_key.key,
                "algorithms": [signing_key.algorithm_name],
                "issuer": self.issuer,
                "options": options,
            }
            if self.audience:
                kwargs["audience"] = self.audience
            else:
                kwargs["options"] = {**options, "verify_aud": False}
            return jwt.decode(token, **kwargs)
        except jwt.PyJWTError as exc:
            raise TokenVerificationError("Invalid or expired access token") from exc


@lru_cache
def get_verifier(issuer: str, audience: str | None = None) -> SupabaseJWTVerifier:
    return SupabaseJWTVerifier(issuer=issuer, audience=audience)
