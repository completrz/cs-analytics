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

df = pd.read_sql("""
SELECT *
FROM rounds
WHERE winner_side IN ('ct', 't')
""", engine)

df.to_csv("tableau/rounds.csv", index=False)

print("Exported tableau/rounds.csv")

trade_df = pd.read_sql("""
WITH ordered_kills AS (
    SELECT
        match_id,
        map_id,
        round,
        attacker_side,
        is_opening_kill,
        time_to_next_kill_s,
        LEAD(attacker_side) OVER (
            PARTITION BY match_id, map_id, round
            ORDER BY kill_ordinal
        ) AS next_kill_side
    FROM kills
),
opening_trades AS (
    SELECT
        match_id,
        map_id,
        round,
        attacker_side AS opening_kill_side,
        CASE
            WHEN time_to_next_kill_s <= 5
             AND next_kill_side <> attacker_side
            THEN TRUE
            ELSE FALSE
        END AS opening_kill_traded
    FROM ordered_kills
    WHERE is_opening_kill = TRUE
      AND attacker_side IN ('ct', 't')
)
SELECT
    o.opening_kill_traded,
    CASE WHEN o.opening_kill_side = r.winner_side THEN 1 ELSE 0 END
        AS opening_side_won
FROM opening_trades o
JOIN rounds r
    ON o.match_id = r.match_id
    AND o.map_id = r.map_id
    AND o.round = r.round;
""", engine)

trade_df.to_csv("tableau/opening_trade.csv", index=False)
print("Exported tableau/opening_trade.csv")