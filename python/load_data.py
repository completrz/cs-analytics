import pandas as pd
from sqlalchemy import create_engine, URL
from getpass import getpass

password = getpass("Postgres password: ")

url = URL.create(
    "postgresql+psycopg2",
    username="postgres",
    password=password,
    host="localhost",
    port=5432,
    database="cs2_analytics"
)

engine = create_engine(url)

tables = [
    ("matches", "data/matches.parquet"),
    ("rounds", "data/rounds.parquet"),
    ("kills", "data/kills.parquet"),
    ("round_player", "data/round_player.parquet")
]

for table, file in tables:
    df = pd.read_parquet(file)
    df.to_sql(
        table,
        engine,
        if_exists="append",
        index=False,
        chunksize=1000
    )
    print(f"Loaded {len(df)} rows into {table}")