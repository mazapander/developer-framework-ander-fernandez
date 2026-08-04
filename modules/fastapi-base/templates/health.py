from fastapi import APIRouter, Response, status

router = APIRouter()


@router.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@router.get("/ready")
def ready(response: Response) -> dict[str, str]:
    # Extend with database/cache checks. Return 503 when a required dependency is unavailable.
    response.status_code = status.HTTP_200_OK
    return {"status": "ready"}
