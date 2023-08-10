SELECT 
	team_name, 
    unique_id, 
	SUM(cnt) as total_games,
	ROUND(SUM(total_xg), 2) as total_xg, 
    ROUND(SUM(total_xga), 2)as total_xga, 
    ROUND(SUM(total_xg), 2)/SUM(cnt) as avg_xg,
    ROUND(SUM(total_xga), 2)/SUM(cnt) as avg_xga
FROM (
	SELECT 
		team.team_name as team_name,
		team.unique_id as unique_id,
		SUM(summ.xg_home) as total_xg,
		SUM(summ.xg_away) as total_xga,
		COUNT(*) as cnt
	FROM team_data_epl_22_23 as team 
	JOIN all_match_summary_stats_epl_22_23 as summ ON summ.home_uid = team.unique_id
	GROUP BY unique_id

	UNION ALL

	SELECT 
		team.team_name as team_name,
		team.unique_id as unique_id,
		SUM(summ.xg_away) as total_xg,
		SUM(summ.xg_home) as total_xga,
		COUNT(*) as cnt
	FROM team_data_epl_22_23 as team 
	JOIN all_match_summary_stats_epl_22_23 as summ ON summ.away_uid = team.unique_id
	GROUP BY unique_id 
) as inter
GROUP BY team_name, unique_id
ORDER BY team_name, unique_id;


