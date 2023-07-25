SELECT 
    m.date,
    o.player_uid,
    p.player_name,
    AVG(o.non_penalty_xg) OVER (
        PARTITION BY o.player_uid 
        ORDER BY m.date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as running_avg_npxg
FROM 
    match_outfield_stats AS o
JOIN 
    players_epl_22_23 AS p ON o.player_uid = p.player_uid
JOIN 
    all_match_summary_stats_epl_22_23 AS m ON o.match_uid = m.match_report_uid
ORDER BY 
    o.player_uid,
    m.date;
