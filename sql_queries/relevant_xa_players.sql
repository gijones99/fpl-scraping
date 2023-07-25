SELECT 
    sub.player_uid,
    sub.player_name,
    ROUND(AVG(sub.running_avg_xa), 3) as avg_ra_xa
FROM player_moving_avg_xa as sub
GROUP BY
    sub.player_uid
HAVING
    avg_ra_xa > 0.05
ORDER BY 
	avg_ra_xa DESC,
    player_uid;