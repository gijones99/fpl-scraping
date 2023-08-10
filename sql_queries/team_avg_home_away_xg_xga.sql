SELECT 
	team.team_name as team_name,
	AVG(summ.xg_home) as avg_xg_home,
    AVG(summ.xg_away) as avg_xga_home,
    AVG(summ2.xg_away) as avg_xg_away,
	AVG(summ2.xg_home) as avg_xga_away
FROM team_data_epl_22_23 as team 
JOIN all_match_summary_stats_epl_22_23 as summ on team.unique_id = summ.home_uid
JOIN all_match_summary_stats_epl_22_23 as summ2 on team.unique_id = summ2.away_uid
GROUP BY unique_id
ORDER BY team_name;