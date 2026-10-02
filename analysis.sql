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