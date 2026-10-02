EXPLAIN ANALYZE
SELECT *
FROM kills
WHERE match_id = 2391545
  AND map_id = 2
ORDER BY round, kill_ordinal;

CREATE INDEX IF NOT EXISTS idx_kills_match_map_round
ON kills (match_id, map_id, round, kill_ordinal);

-- After
ANALYZE kills;

EXPLAIN ANALYZE
SELECT *
FROM kills
WHERE match_id = 2391545
  AND map_id = 2
ORDER BY round, kill_ordinal;