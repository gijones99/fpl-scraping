    SELECT 
        `team`.`team_name` AS `team_name`,
        `team`.`unique_id` AS `unique_id`,
		summ.match_report_uid AS match_uid,
        `summ`.`date` AS `match_date`,
        `summ`.`xg_home` AS `xg`,
        `summ`.`xg_away` AS `xga`,
        score,
        'Home' AS home_away,
        SUBSTRING_INDEX(score, '–', 1) AS goals_scored,
		SUBSTRING_INDEX(score, '–', -1)  AS goals_conceded,
		CASE 
			WHEN SUBSTRING_INDEX(score, '–', 1) > SUBSTRING_INDEX(score, '–', -1) THEN "Win"
			WHEN SUBSTRING_INDEX(score, '–', 1) < SUBSTRING_INDEX(score, '–', -1) THEN "Lose"
			WHEN SUBSTRING_INDEX(score, '–', 1) = SUBSTRING_INDEX(score, '–', -1) THEN "Draw"
		END as win_draw_lose
            
    FROM
        (`team_data_epl_22_23` `team`
        JOIN `all_match_summary_stats_epl_22_23` `summ` ON ((`summ`.`home_uid` = `team`.`unique_id`))) 
    UNION ALL 
    SELECT 
        `team`.`team_name` AS `team_name`,
        `team`.`unique_id` AS `unique_id`,
        summ.match_report_uid AS match_uid,
        `summ`.`date` AS `match_date`,
        `summ`.`xg_away` AS `xg`,
        `summ`.`xg_home` AS `xga`,
        score,
        'Away' AS home_away,
        SUBSTRING_INDEX(score, '–', -1) AS goals_scored,
		SUBSTRING_INDEX(score, '–', 1)  AS goals_conceded,
        CASE 
			WHEN SUBSTRING_INDEX(score, '–', -1) > SUBSTRING_INDEX(score, '–', 1) THEN "Win"
			WHEN SUBSTRING_INDEX(score, '–', -1) < SUBSTRING_INDEX(score, '–', 1) THEN "Lose"
			WHEN SUBSTRING_INDEX(score, '–', -1) = SUBSTRING_INDEX(score, '–', 1) THEN "Draw"
		END as win_draw_lose
    FROM
        (`team_data_epl_22_23` `team`
        JOIN `all_match_summary_stats_epl_22_23` `summ` ON ((`summ`.`away_uid` = `team`.`unique_id`)))