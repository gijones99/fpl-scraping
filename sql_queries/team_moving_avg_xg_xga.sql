SELECT 
	team_name, 
	unique_id,
    match_date,
	ROUND(AVG(xg) OVER (
        PARTITION BY unique_id 
        ORDER BY match_date 
        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
    ), 2) as running_avg_2_team_xg,
	ROUND(AVG(xg) OVER (
        PARTITION BY unique_id 
        ORDER BY match_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) as running_avg_3_team_xg,
	ROUND(AVG(xga) OVER (
        PARTITION BY unique_id 
        ORDER BY match_date 
        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
    ), 2) as running_avg_2_team_xga,
	ROUND(AVG(xga) OVER (
        PARTITION BY unique_id 
        ORDER BY match_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2)as running_avg_3_team_xga
FROM 
(
	SELECT 
		team_name, 
		unique_id,
		xg,
		xga,
		match_date
	FROM indiv_match_stats_by_team 
) as cte
ORDER BY team_name, unique_id, match_date;

