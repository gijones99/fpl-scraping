-- Define the parameter (user-defined variable)
SET @player_name = 'Alex Moreno';

-- Use the parameter in the SELECT statement
SELECT player, match_uid, non_penalty_xg, expected_assists, summ.date
FROM match_outfield_stats as mo
left join `all_match_summary_stats_epl_22_23` as summ on mo.match_uid = summ.match_report_uid
WHERE player = @player_name
ORDER BY date ASC;


