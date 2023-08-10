SELECT 
	team_name, 
    unique_id, 
    home_away, 
    ROUND(AVG(goals_scored), 2) as avg_scored,
	ROUND(AVG(goals_conceded), 2) as avg_conceded,
    ROUND(AVG(xg), 2) as avg_xg,
	ROUND(AVG(xga), 2) as avg_xga
FROM indiv_match_stats_by_team
GROUP BY unique_id, team_name, home_away
ORDER BY team_name, home_away desc