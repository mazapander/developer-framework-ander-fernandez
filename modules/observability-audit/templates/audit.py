from __future__ import annotations

from typing import Any

from sqlalchemy.orm import Session

from app.models.audit_log import AuditLog


def write_audit_event(
    session: Session,
    *,
    action: str,
    resource_type: str,
    outcome: str,
    actor_id: str | None = None,
    resource_id: str | None = None,
    request_id: str | None = None,
    metadata: dict[str, Any] | None = None,
) -> AuditLog:
    event = AuditLog(
        actor_id=actor_id,
        action=action,
        resource_type=resource_type,
        resource_id=resource_id,
        outcome=outcome,
        request_id=request_id,
        metadata_json=metadata or {},
    )
    session.add(event)
    return event
