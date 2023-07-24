CREATE VIEW `npxg_percentiles` AS
SELECT 
    player_uid,
    non_penalty_xg,
    ranking,
    1 - (ranking / MAX(ranking) OVER ()) AS percentile_rank
FROM 
    (
        SELECT 
            player_uid,
            non_penalty_xg,
            RANK() OVER (ORDER BY non_penalty_xg DESC) AS ranking
        FROM 
            match_outfield_stats
        WHERE 
            non_penalty_xg IS NOT NULL
        ORDER BY 
            non_penalty_xg DESC
    ) AS derived_table;



