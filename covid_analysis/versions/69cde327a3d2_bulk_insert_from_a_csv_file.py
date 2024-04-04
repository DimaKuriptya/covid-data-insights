"""bulk insert from a csv file

Revision ID: 69cde327a3d2
Revises: 
Create Date: 2024-03-24 13:40:14.695922

"""
from typing import Sequence, Union

from alembic import op
from utils import deaths_df, vaccinations_df


# revision identifiers, used by Alembic.
revision: str = '69cde327a3d2'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    deaths_df.to_sql('covid_deaths', op.get_bind(), if_exists='replace', index=False)
    vaccinations_df.to_sql('covid_vaccinations', op.get_bind(), if_exists='replace', index=False)


def downgrade() -> None:
    op.drop_table('covid_deaths')
    op.drop_table('covid_vaccinations')
