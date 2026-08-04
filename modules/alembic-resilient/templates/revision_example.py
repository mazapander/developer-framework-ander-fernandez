"""Example resilient Alembic revision.

Replace identifiers before use. This file is documentation and should not be copied into a live
versions directory unchanged.
"""

from alembic import op
import sqlalchemy as sa

from app.db.migrations.schema_guard import ensure_column, ensure_index

revision = "replace_me"
down_revision = "replace_me"
branch_labels = None
depends_on = None


def upgrade() -> None:
    ensure_column(
        op,
        table_name="users",
        column=sa.Column("display_name", sa.String(length=120), nullable=True),
    )
    ensure_index(
        op,
        index_name="ix_users_display_name",
        table_name="users",
        columns=["display_name"],
    )


def downgrade() -> None:
    # Downgrade remains explicit. Do not drop pre-existing objects that an upgrade skipped.
    op.drop_index("ix_users_display_name", table_name="users")
    op.drop_column("users", "display_name")
