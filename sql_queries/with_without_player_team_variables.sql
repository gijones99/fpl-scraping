SET @player_name = 'Erling Haaland';
SET @player_team = 'Manchester City'; 

-- Step 1: Find the club's UID
SET @team_uid = (
    SELECT unique_id
    FROM team_data_epl_22_23
    WHERE team_name = @player_team
    LIMIT 1
);

-- Step 2: Find the player's UID
SET @player_uid = (
    SELECT player_uid
    FROM players_epl_22_23
    WHERE player_name = @player_name
    LIMIT 1
);

SELECT player_status, AVG(xg) as avg_xg, AVG(xga) as avg_xga, COUNT(player_status) as cnt
FROM (
	SELECT 
		team_stats.match_uid,
		@team_uid as "team_uid",
		xg,
		xga,
		CASE
			WHEN with_players.match_uid IS NULL THEN "Without Player"
			ELSE "With Player"
			END AS player_status
	FROM indiv_match_stats_by_team as team_stats
	LEFT JOIN (
		SELECT DISTINCT match_uid -- player is in match
		FROM match_outfield_stats AS mo
		JOIN team_data_epl_22_23 as team on team.unique_id = mo.team_uid 
		WHERE player_uid = @player_uid and mo.team_uid = @team_uid 
		) as with_players ON with_players.match_uid = team_stats.match_uid
	WHERE team_stats.unique_id = @team_uid
    ) as cte
GROUP BY player_status



