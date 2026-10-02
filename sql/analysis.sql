--Does getting the opening kill make a side more likely to win the round?
SELECT
    opening_kill_side,
    winner_side,
    COUNT(*) AS rounds
FROM rounds
WHERE opening_kill_side IN ('ct', 't')
GROUP BY opening_kill_side, winner_side
ORDER BY opening_kill_side, rounds DESC;

--calculate opening-win rate
SELECT
    opening_kill_side,
    COUNT(*) AS total_rounds,
    SUM(CASE WHEN opening_kill_side = winner_side THEN 1 ELSE 0 END) AS rounds_won,
    ROUND(
        100.0 * SUM(CASE WHEN opening_kill_side = winner_side THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS win_rate
FROM rounds
WHERE opening_kill_side IN ('ct', 't')
GROUP BY opening_kill_side; 
-- Finding: Getting the opening kill is strongly associated with winning the round, 
-- with T-side opening kills showing a slightly higher round win rate than CT-side opening kills.



-- Does opening-kill timing affects round win rate?
SELECT
    CASE
        WHEN opening_kill_seconds < 20 THEN '0-20 sec'
        WHEN opening_kill_seconds < 40 THEN '20-40 sec'
        WHEN opening_kill_seconds < 60 THEN '40-60 sec'
        ELSE '60+ sec'
    END AS opening_kill_time,

    COUNT(*) AS rounds,

    ROUND(
        100.0 * SUM(
            CASE WHEN opening_kill_side = winner_side THEN 1 ELSE 0 END
        ) / COUNT(*),
        2
    ) AS win_rate

FROM rounds
WHERE opening_kill_side IN ('ct', 't')
  AND opening_kill_seconds IS NOT NULL

GROUP BY opening_kill_time
ORDER BY MIN(opening_kill_seconds);
--Finding: The timing doesn't affect affect win rate much.



--kill differential vs. round outcome
SELECT
    (ct_kills - t_kills) AS kill_difference,
    COUNT(*) AS rounds,
    ROUND(
        100.0 * SUM(CASE WHEN winner_side = 'ct' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS ct_win_rate
FROM rounds
WHERE winner_side IN ('ct', 't')
GROUP BY kill_difference
ORDER BY kill_difference;



--which maps are more CT- or T-sided
SELECT
    map_name,
    COUNT(*) AS rounds,
    ROUND(
        100.0 * SUM(CASE WHEN winner_side = 'ct' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS ct_win_rate,
    ROUND(
        100.0 * SUM(CASE WHEN winner_side = 't' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS t_win_rate
FROM rounds
WHERE winner_side IN ('ct', 't')
GROUP BY map_name
ORDER BY ct_win_rate DESC;
-- Map choice affects side advantage, with Nuke leaning CT and Anubis leaning T in this dataset.



--bomb plants vs round wins
SELECT
    has_bomb_plant,
    COUNT(*) AS rounds,
    ROUND(
        100.0 * SUM(CASE WHEN winner_side = 't' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS t_win_rate
FROM rounds
WHERE winner_side IN ('ct', 't')
GROUP BY has_bomb_plant
ORDER BY has_bomb_plant;
-- T-side round wins are strongly associated with successfully getting the bomb planted.



-- Does opening kill matter once you account for whether T planted bomb or not
SELECT
    opening_kill_side,
    has_bomb_plant,
    COUNT(*) AS rounds,
    ROUND(
        100.0 * SUM(CASE WHEN winner_side = 't' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS t_win_rate
FROM rounds
WHERE winner_side IN ('ct', 't')
  AND opening_kill_side IN ('ct', 't')
GROUP BY opening_kill_side, has_bomb_plant
ORDER BY opening_kill_side, has_bomb_plant;
-- Getting the opening kill helps, but getting the bomb planted changes
-- the outcome dramatically even after losing the opening kill.



--bomb site performance by map. FAILED: DOESNT HAVE A SITE. DROPPED
/*
SELECT
    map_name,
    bomb_site,
    COUNT(*) AS rounds,
    ROUND(
        100.0 * SUM(CASE WHEN winner_side = 't' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS t_win_rate
FROM rounds
WHERE has_bomb_plant = TRUE
  AND bomb_site IS NOT NULL
  AND winner_side IN ('ct', 't')
GROUP BY map_name, bomb_site
ORDER BY map_name, bomb_site;

SELECT
    bomb_site,
    COUNT(*) AS rounds
FROM rounds
WHERE has_bomb_plant = TRUE
GROUP BY bomb_site
ORDER BY rounds DESC;
*/
-- no finding



--opening-kill weapon vs round win rate:
SELECT
    opening_weapon,
    COUNT(*) AS rounds,
    ROUND(
        100.0 * SUM(CASE WHEN opening_kill_side = winner_side THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS opening_kill_win_rate
FROM rounds
WHERE opening_kill_side IN ('ct', 't')
  AND opening_weapon IS NOT NULL
GROUP BY opening_weapon
HAVING COUNT(*) >= 100
ORDER BY opening_kill_win_rate DESC;

--seperate by side
SELECT
    opening_kill_side,
    opening_weapon,
    COUNT(*) AS rounds,
    ROUND(
        100.0 * SUM(CASE WHEN opening_kill_side = winner_side THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS win_rate
FROM rounds
WHERE opening_kill_side IN ('ct', 't')
  AND opening_weapon IS NOT NULL
GROUP BY opening_kill_side, opening_weapon
HAVING COUNT(*) >= 100
ORDER BY opening_kill_side, win_rate DESC;
-- So weapon choice is associated with the outcome, but economy/round type is probably influencing this heavily



--Does opening-kill advantage change by map
SELECT
    map_name,
    opening_kill_side,
    COUNT(*) AS rounds,
    ROUND(
        100.0 * SUM(CASE WHEN opening_kill_side = winner_side THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS win_rate
FROM rounds
WHERE opening_kill_side IN ('ct', 't')
GROUP BY map_name, opening_kill_side
ORDER BY map_name, opening_kill_side;
-- map affects how valuable the opening kill is, especially on Anubis.



-- Clutch situations vs round wins
SELECT
    had_clutch_context,
    COUNT(*) AS rounds,
    ROUND(
        100.0 * SUM(CASE WHEN winner_side = 'ct' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS ct_win_rate
FROM rounds
WHERE winner_side IN ('ct', 't')
GROUP BY had_clutch_context
ORDER BY had_clutch_context;
-- clutch context doesn’t change the outcome nearly as much as opening kills or bomb plants


-- 1v1 situations
SELECT
    had_1v1,
    COUNT(*) AS rounds,
    ROUND(
        100.0 * SUM(CASE WHEN winner_side = 'ct' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS ct_win_rate
FROM rounds
WHERE winner_side IN ('ct', 't')
GROUP BY had_1v1
ORDER BY had_1v1;
-- T wins 1v1 rounds more often than CT



--headshots vs round wins
SELECT
    CASE
        WHEN n_headshots = 0 THEN '0'
        WHEN n_headshots = 1 THEN '1'
        WHEN n_headshots = 2 THEN '2'
        ELSE '3+'
    END AS headshots,
    COUNT(*) AS rounds,
    ROUND(
        100.0 * SUM(CASE WHEN winner_side = 'ct' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS ct_win_rate
FROM rounds
WHERE winner_side IN ('ct', 't')
GROUP BY headshots
ORDER BY MIN(n_headshots);
--misleading

-- Does having more headshots than the opponent is associated with winning
SELECT
    (ct_headshots - t_headshots) AS headshot_difference,
    COUNT(*) AS rounds,
    ROUND(
        100.0 * SUM(CASE WHEN winner_side = 'ct' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS ct_win_rate
FROM rounds
WHERE winner_side IN ('ct', 't')
GROUP BY headshot_difference
ORDER BY headshot_difference;
-- headshot differential tracks round outcome closely



--if the opening kill gets traded within 5 seconds, does the opening-kill advantage mostly disappear?
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
)

SELECT
    opening_kill_traded,
    COUNT(*) AS rounds,
    ROUND(
        100.0 * SUM(
            CASE WHEN o.opening_kill_side = r.winner_side THEN 1 ELSE 0 END
        ) / COUNT(*),
        2
    ) AS opening_side_win_rate
FROM opening_trades o
JOIN rounds r
    ON o.match_id = r.match_id
    AND o.map_id = r.map_id
    AND o.round = r.round
GROUP BY opening_kill_traded;
-- Opening kill not traded within 5 sec: opening side wins 78.47%.
-- Opening kill traded within 5 sec: opening side wins only 54.01%
--So a quick trade almost wipes out the opening-kill advantage.



--Does this differ for CT vs T:
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
)

SELECT
    o.opening_kill_side,
    o.opening_kill_traded,
    COUNT(*) AS rounds,
    ROUND(
        100.0 * SUM(
            CASE WHEN o.opening_kill_side = r.winner_side THEN 1 ELSE 0 END
        ) / COUNT(*),
        2
    ) AS win_rate
FROM opening_trades o
JOIN rounds r
    ON o.match_id = r.match_id
    AND o.map_id = r.map_id
    AND o.round = r.round
GROUP BY o.opening_kill_side, o.opening_kill_traded
ORDER BY o.opening_kill_side, o.opening_kill_traded;
-- A quick trade heavily reduces the value of the opening kill for both sides.
-- It hurts CT even more, dropping the advantage basically to a coin flip.


--how long it takes for the trade to happen
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

trades AS (
    SELECT
        match_id,
        map_id,
        round,
        attacker_side AS opening_kill_side,
        time_to_next_kill_s,
        CASE
            WHEN time_to_next_kill_s <= 2 THEN '0-2 sec'
            WHEN time_to_next_kill_s <= 5 THEN '2-5 sec'
            WHEN time_to_next_kill_s <= 10 THEN '5-10 sec'
            ELSE '10+ sec'
        END AS trade_time
    FROM ordered_kills
    WHERE is_opening_kill = TRUE
      AND attacker_side IN ('ct', 't')
      AND next_kill_side <> attacker_side
)

SELECT
    trade_time,
    COUNT(*) AS rounds,
    ROUND(
        100.0 * SUM(
            CASE WHEN t.opening_kill_side = r.winner_side THEN 1 ELSE 0 END
        ) / COUNT(*),
        2
    ) AS opening_side_win_rate
FROM trades t
JOIN rounds r
    ON t.match_id = r.match_id
    AND t.map_id = r.map_id
    AND t.round = r.round
GROUP BY trade_time
ORDER BY MIN(time_to_next_kill_s);