SELECT 
    sub.player_uid,
    sub.player_name,
    ROUND(AVG(sub.running_avg_npxg), 3) as avg_ra_npxg
FROM player_moving_avg_npxg as sub
GROUP BY
    sub.player_uid
HAVING
    avg_ra_npxg > 0.05
ORDER BY 
	avg_ra_npxg DESC,
    sub.player_uid;