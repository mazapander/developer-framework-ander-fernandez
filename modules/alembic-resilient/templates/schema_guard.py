from __future__ import annotations

import logging
from dataclasses import dataclass
from typing import Any

import sqlalchemy as sa
from alembic.operations import Operations
from sqlalchemy.engine.reflection import Inspector

logger = logging.getLogger("alembic.schema_guard")


class SchemaConflictError(RuntimeError):
    """Raised when a database object exists but differs from the migration expectation."""


@dataclass(frozen=True)
class GuardResult:
    status: str
    object_type: str
    object_name: str


def _inspector(operations: Operations) -> Inspector:
    return sa.inspect(operations.get_bind())


def _log(status: str, operation: str, object_type: str, object_name: str, **details: Any) -> GuardResult:
    logger.info(
        "ALEMBIC_GUARD status=%s operation=%s object_type=%s object_name=%s details=%s",
        status,
        operation,
        object_type,
        object_name,
        details,
    )
    return GuardResult(status=status, object_type=object_type, object_name=object_name)


def _type_signature(column_type: sa.types.TypeEngine[Any]) -> str:
    return str(column_type).lower().replace(" ", "")


def ensure_table(
    operations: Operations,
    table_name: str,
    *columns: sa.Column[Any],
    schema: str | None = None,
    **kwargs: Any,
) -> GuardResult:
    inspector = _inspector(operations)
    qualified_name = f"{schema}.{table_name}" if schema else table_name

    if not inspector.has_table(table_name, schema=schema):
        operations.create_table(table_name, *columns, schema=schema, **kwargs)
        return _log("APPLIED", "create_table", "table", qualified_name)

    existing = {column["name"]: column for column in inspector.get_columns(table_name, schema=schema)}
    expected = {column.name: column for column in columns}
    missing = sorted(set(expected) - set(existing))
    incompatible = []

    for name in sorted(set(expected) & set(existing)):
        expected_column = expected[name]
        current_column = existing[name]
        if _type_signature(expected_column.type) != _type_signature(current_column["type"]):
            incompatible.append(
                f"{name}: expected={expected_column.type}, actual={current_column['type']}"
            )

    if missing or incompatible:
        _log(
            "CONFLICT",
            "create_table",
            "table",
            qualified_name,
            missing_columns=missing,
            incompatible_columns=incompatible,
        )
        raise SchemaConflictError(
            f"Table {qualified_name} exists but differs from the expected schema"
        )

    return _log("SKIPPED_EQUAL", "create_table", "table", qualified_name)


def ensure_column(
    operations: Operations,
    table_name: str,
    column: sa.Column[Any],
    schema: str | None = None,
) -> GuardResult:
    inspector = _inspector(operations)
    qualified_name = f"{schema}.{table_name}.{column.name}" if schema else f"{table_name}.{column.name}"

    if not inspector.has_table(table_name, schema=schema):
        _log("CONFLICT", "add_column", "column", qualified_name, reason="table_missing")
        raise SchemaConflictError(f"Cannot add {qualified_name}: table does not exist")

    existing_columns = {
        reflected["name"]: reflected
        for reflected in inspector.get_columns(table_name, schema=schema)
    }
    existing = existing_columns.get(column.name)

    if existing is None:
        operations.add_column(table_name, column, schema=schema)
        return _log("APPLIED", "add_column", "column", qualified_name)

    same_type = _type_signature(existing["type"]) == _type_signature(column.type)
    same_nullable = bool(existing.get("nullable", True)) == bool(column.nullable)

    if same_type and same_nullable:
        return _log("SKIPPED_EQUAL", "add_column", "column", qualified_name)

    _log(
        "CONFLICT",
        "add_column",
        "column",
        qualified_name,
        expected_type=str(column.type),
        actual_type=str(existing["type"]),
        expected_nullable=column.nullable,
        actual_nullable=existing.get("nullable"),
    )
    raise SchemaConflictError(
        f"Column {qualified_name} exists but differs from the expected definition"
    )


def ensure_index(
    operations: Operations,
    index_name: str,
    table_name: str,
    columns: list[str],
    *,
    unique: bool = False,
    schema: str | None = None,
) -> GuardResult:
    inspector = _inspector(operations)
    qualified_name = f"{schema}.{index_name}" if schema else index_name
    indexes = {
        index["name"]: index
        for index in inspector.get_indexes(table_name, schema=schema)
    }
    existing = indexes.get(index_name)

    if existing is None:
        operations.create_index(
            index_name,
            table_name,
            columns,
            unique=unique,
            schema=schema,
        )
        return _log("APPLIED", "create_index", "index", qualified_name)

    same_columns = list(existing.get("column_names") or []) == columns
    same_unique = bool(existing.get("unique", False)) == unique

    if same_columns and same_unique:
        return _log("SKIPPED_EQUAL", "create_index", "index", qualified_name)

    _log(
        "CONFLICT",
        "create_index",
        "index",
        qualified_name,
        expected_columns=columns,
        actual_columns=existing.get("column_names"),
        expected_unique=unique,
        actual_unique=existing.get("unique"),
    )
    raise SchemaConflictError(
        f"Index {qualified_name} exists but differs from the expected definition"
    )
