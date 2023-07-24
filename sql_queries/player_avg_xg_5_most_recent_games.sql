SELECT 
    t.team_name,
    p.player_name,
	ROUND(AVG(o.non_penalty_xg), 2) AS avg_non_penalty_xG,
    ROUND(AVG(o.xG), 2) AS avg_xG,
    COUNT(*) AS games_played
FROM 
    match_outfield_stats AS o
JOIN 
    players_epl_22_23 AS p ON o.player_uid = p.player_uid
JOIN 
    all_match_summary_stats_epl_22_23 AS m ON o.match_uid = m.match_report_uid
JOIN 
    team_data_epl_22_23 AS t ON o.team_uid = t.unique_id
WHERE 
    o.xG IS NOT NULL
    AND m.match_report_uid IN (
        SELECT match_report_uid
        FROM (
            SELECT match_report_uid
            FROM all_match_summary_stats_epl_22_23
            WHERE home_uid = t.unique_id
               OR away_uid = t.unique_id
            ORDER BY date DESC
            LIMIT 5
        ) AS recent_matches
    )
GROUP BY 
    t.team_name,
    p.player_name
ORDER BY 
    avg_non_penalty_xG DESC,
    avg_xG DESC,
    games_played DESC,
    t.team_name;

