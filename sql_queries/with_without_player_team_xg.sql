-- Matches where Ivan Toney played
SELECT 
    'With Ivan Toney' AS player_status,
    ROUND(AVG(o.xG), 2) AS avg_player_xG,
    ROUND(AVG(IF(o.team_uid = m.home_uid, m.xg_home, m.xg_away)), 2) AS avg_team_xG,
    COUNT(DISTINCT o.match_uid) AS matches_played,
    GROUP_CONCAT(DISTINCT IF(m.home_uid = "cd051869", t_away.team_name, t_home.team_name)) AS opponent_teams
FROM 
    match_outfield_stats AS o
JOIN 
    all_match_summary_stats_epl_22_23 AS m ON o.match_uid = m.match_report_uid
JOIN 
    team_data_epl_22_23 AS t_home ON m.home_uid = t_home.unique_id
JOIN 
    team_data_epl_22_23 AS t_away ON m.away_uid = t_away.unique_id
WHERE 
    o.team_uid = "cd051869"
    AND o.match_uid IN (
        SELECT match_uid
        FROM match_outfield_stats
        WHERE player = "Ivan Toney"
    )
UNION ALL
-- Matches where Ivan Toney did not play
SELECT 
    'Without Ivan Toney' AS player_status,
    ROUND(AVG(o.xG), 2) AS avg_player_xG,
    ROUND(AVG(IF(o.team_uid = m.home_uid, m.xg_home, m.xg_away)), 2) AS avg_team_xG,
    COUNT(DISTINCT o.match_uid) AS matches_played,
    GROUP_CONCAT(DISTINCT IF(m.home_uid = "cd051869", t_away.team_name, t_home.team_name)) AS opponent_teams
FROM 
    match_outfield_stats AS o
JOIN 
    all_match_summary_stats_epl_22_23 AS m ON o.match_uid = m.match_report_uid
JOIN 
    team_data_epl_22_23 AS t_home ON m.home_uid = t_home.unique_id
JOIN 
    team_data_epl_22_23 AS t_away ON m.away_uid = t_away.unique_id
WHERE 
    o.team_uid = "cd051869"
    AND o.match_uid NOT IN (
        SELECT match_uid
        FROM match_outfield_stats
        WHERE player = "Ivan Toney"
    );





