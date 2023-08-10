SELECT 
	team_name, 
	unique_id,
	ROUND(AVG(xg), 2) AS avg_5_xg,
	ROUND(AVG(xga), 2) AS avg_5_xga,
	GROUP_CONCAT(win_draw_lose ORDER BY match_date DESC) AS recent_form
FROM 
(
	SELECT 
		team_name, 
		unique_id,
		xg,
		xga,
		match_date,
        win_draw_lose,
		ROW_NUMBER() OVER (PARTITION BY unique_id ORDER BY match_date desc) AS row_num
	FROM indiv_match_stats_by_team 
) as cte
WHERE row_num <= 5
GROUP BY team_name, unique_id;


