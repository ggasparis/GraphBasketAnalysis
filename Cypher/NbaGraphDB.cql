// players
CREATE CONSTRAINT ON (p:PLAYER_ID) ASSERT p.id IS UNIQUE;
CREATE CONSTRAINT ON (a:PLAYER_NAME) ASSERT a.name IS UNIQUE;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'file:///players.csv' AS line

MERGE (team:TEAM_ID {id: ToInteger(line.TEAM_ID) })
MERGE (player:PLAYER_ID {id: ToInteger(line.PLAYER_ID) })

MERGE (playerName:PLAYER_NAME {name: toUpper(line.PLAYER_NAME) })
MERGE (season:SEASON {name: ToInteger(line.SEASON) })

CREATE (player)-[:PLAYS_AT]->(team)
CREATE (player)-[:HAS_NAME]->(playerName)
CREATE (player)-[:PLAYED_IN_SEASON]->(season)

;

//teams
CREATE CONSTRAINT ON (t:TEAM_ID) ASSERT t.id IS UNIQUE;
CREATE CONSTRAINT ON (c:CITY) ASSERT c.name IS UNIQUE;
CREATE CONSTRAINT ON (r:ARENA) ASSERT r.name IS UNIQUE;
CREATE CONSTRAINT ON (n:NICKNAME) ASSERT n.name IS UNIQUE;
CREATE CONSTRAINT ON (b:ABBREVIATION) ASSERT b.name IS UNIQUE;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM
'file:///teams.csv' AS line

MATCH (team:TEAM_ID {id: ToInteger(line.TEAM_ID) })

MERGE (leagueID:LEAGUE_ID {id: ToInteger(line.LEAGUE_ID) })
MERGE (minYear:MIN_YEAR {year: ToInteger(line.MIN_YEAR) })
MERGE (maxYear:MAX_YEAR {year: ToInteger(line.MAX_YEAR) })
MERGE (abbreviation:ABBREVIATION {name: toUpper(line.ABBREVIATION) })
MERGE (nickname:NICKNAME {name: toUpper(line.NICKNAME) })
MERGE (yearFounded:YEARFOUNDED {year: ToInteger(line.YEARFOUNDED) })
MERGE (city:CITY {name: toUpper(line.CITY) })
MERGE (arena:ARENA {name: toUpper(line.ARENA) })
MERGE (owner:OWNER {name: toUpper(line.OWNER) })
MERGE (general:GENERALMANAGER {name: toUpper(line.GENERALMANAGER) })
MERGE (head:HEADCOACH {name: toUpper(line.HEADCOACH) })
MERGE (dTeam:DLEAGUEAFFILIATION {name: toUpper(line.DLEAGUEAFFILIATION) })

MATCH (arena:ARENA {name: toUpper(line.ARENA) })
MERGE (aCap:ARENACAPACITY {arena_CapNum: coalesce(ToInteger(line.ARENACAPACITY), 0) })
CREATE (arena)-[:HAS_CAPACITY]->(aCap)

CREATE (team)-[:IN_LEAGUE]->(leagueID)
CREATE (team)-[:IN]->(city)
CREATE (team)-[:TO]->(arena)
CREATE (team)-[:MIN_YEAR]->(minYear)
CREATE (team)-[:MAX_YEAR]->(maxYear)
CREATE (team)-[:ABBR]->(abbreviation)
CREATE (team)-[:HAS_NICKNAME]->(nickname)
CREATE (team)-[:FOUNDED]->(yearFounded)
CREATE (team)-[:OWNED_BY]->(owner)
CREATE (team)-[:MANAGED_BY]->(general)
CREATE (team)-[:COACHED_BY]->(head)

CREATE (dTeam)-[d:HAS]->(team)
SET d.dleague = CASE line.DLEAGUEAFFILIATION WHEN 'No Affiliate' THEN true ELSE false END

;

//games
CREATE CONSTRAINT ON (g:GAME_ID) ASSERT g.id IS UNIQUE;
//CALL apoc.periodic.iterate('CALl apoc.load.csv('//ranking.csv') yield map as line return line ',' MATCH (team:TEAM_ID {id: ToInteger(line.TEAM_ID) }) MERGE (sDate:STANDINGSDATE {standing_date: date(line.STANDINGSDATE) }) CREATE (team)-[:RECORD_DATE]->(sDate) ', {batchSize:10000, iterateList:true, parallel:true})
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'file:///games-1.csv' AS line

MATCH (game:GAME_ID {id: ToInteger(line.GAME_ID) })
MATCH (home_team:TEAM_ID {id: ToInteger(line.HOME_TEAM_ID) })
MATCH (visitor_team:TEAM_ID {id: ToInteger(line.VISITOR_TEAM_ID) })
MATCH (team_home:TEAM_ID {id: ToInteger(line.TEAM_ID_home) })
MATCH (team_away:TEAM_ID {id: ToInteger(line.TEAM_ID_away) })

MATCH (season:SEASON {name: ToInteger(line.SEASON) })
CREATE (game)-[:IN_SEASON]->(season)
MERGE (game_date:GAME_DATE_EST {date: date(line.GAME_DATE_EST) })
CREATE (game)-[:ON_DATE]->(game_date)
MERGE (gs:GAME_STATUS_TEXT {game_satus: toUpper(line.GAME_STATUS_TEXT) })
CREATE (game)-[:GAME_STATUS_IS]->(gs)
// home team stats
MERGE (ptsH:PTS_home {pts_home: coalesce(ToInteger(line.PTS_home), 0) })
CREATE (game)-[:HAS_PTS_H]->(ptsH)
MERGE (fgPctHome:FG_PCT_home {fg_pct_H: coalesce(toFloat(line.FG_PCT_home), 0.0) })
CREATE (game)-[:HAS_FG_H]->(fgPctHome)
MERGE (ftPctHome:FT_PCT_home {ft_pct_H: coalesce(toFloat(line.FT_PCT_home), 0.0) })
CREATE (game)-[:HAS_FT_H]->(ftPctHome)
MERGE (fg3PctHome:FG3_PCT_home {fg3_pct_H: coalesce(toFloat(line.FG3_PCT_home), 0.0) })
CREATE (game)-[:HAS_FG3_H]->(fg3PctHome)
MERGE (astH:AST_home {ast_home: coalesce(ToInteger(line.AST_home), 0) })
CREATE (game)-[:HAS_AST_H]->(astH)
MERGE (rebH:REB_home {reb_home: coalesce(ToInteger(line.REB_home), 0) })
CREATE (game)-[:HAS_REB_H]->(rebH)
// away team stats
MERGE (ptsA:PTS_away {pts_away: coalesce(ToInteger(line.PTS_away), 0) })
CREATE (game)-[:HAS_PTS_A]->(ptsA)
//FOREACH (n IN (CASE WHEN line.FG_PCT_away IS NULL THEN [] ELSE [1] END) |
//      MERGE (fgPctAway:FG_PCT_away {fg_pct_A: ToInteger(line.FG_PTS_away) })
//      CREATE (game)-[:HAS_FG_A]->(fgPctAway))
MERGE (fgPctAway:FG_PCT_away {fg_pct_away: coalesce(toFloat(line.FG_PCT_away), 0.0) })
CREATE (game)-[:HAS_FG_A]->(fgPctAway)
MERGE (ftPctAway:FT_PCT_away {ft_pct_A: coalesce(toFloat(line.FT_PCT_away), 0.0) })
CREATE (game)-[:HAS_FT_A]->(ftPctAway)
MERGE (fg3PctAway:FG3_PCT_away {fg3_pct_A: coalesce(toFloat(line.FG3_PCT_away), 0.0) })
CREATE (game)-[:HAS_FG3_A]->(fg3PctAway)
MERGE (astA:AST_away {ast_away: coalesce(ToInteger(line.AST_away), 0) })
CREATE (game)-[:HAS_AST_A]->(astA)
MERGE (rebA:REB_away {reb_away: coalesce(ToInteger(line.REB_away), 0) })
CREATE (game)-[:HAS_REB_A]->(rebA)
MERGE (win:HOME_TEAM_WINS {home_win: ToInteger(line.HOME_TEAM_WINS) })
CREATE (game)-[:HOME_WINS]->(win)
SET win.HomeWins = CASE line.HOME_TEAM_WINS WHEN '1' THEN true ELSE false END

CREATE (game)-[:HOME_TEAM_IS]->(home_team)
CREATE (game)-[:AWAY_TEAM_IS]->(away_team)
CREATE (game)-[:TEAM_HOME]->(team_home)
CREATE (game)-[:TEAM_AWAY]->(team_away)

;

//ranking
CREATE CONSTRAINT ON (e:TEAM) ASSERT e.name IS UNIQUE;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'file:///ranking.csv' AS line

MATCH (team:TEAM_ID {id: ToInteger(line.TEAM_ID) })
MATCH (leagueID:LEAGUE_ID {id: ToInteger(line.LEAGUE_ID) })

MERGE (sID:SEASON_ID {season_id: ToInteger(line.SEASON_ID) })
CREATE (team)-[:AT_SEASON]->(sID)

MERGE (sDate:STANDINGSDATE {standing_date: date(line.STANDINGSDATE) })
CREATE (team)-[:RECORD_DATE]->(sDate)

MERGE (conf:CONFERENCE {conference: toUpper(line.CONFERENCE) })
CREATE (team)-[:IS_IN]->(conf)
MERGE (g:G {general_points: ToInteger(line.G) })
CREATE (team)-[:GENERAL_MATCHES]->(g)
MERGE (w:W {wins: ToInteger(line.W) })
CREATE (team)-[:TOTAl_WINS]->(w)
MERGE (l:L {loses: ToInteger(line.L) })
CREATE (team)-[:TOTAL_LOSES]->(l)
MERGE (winp:W_PCT {win_pct: toFloat(line.W_PCT) })
CREATE (team)-[:TOTAL_WINS_PCT]->(winp)
MERGE (h:HOME_RECORD {home_record: toString(line.HOME_RECORD) })
CREATE (team)-[:HOME_RECORD]->(h)
MERGE (r:ROAD_RECORD {road_record: toString(line.ROAD_RECORD) })
CREATE (team)-[:ROAD_RECORD]->(r)
;


// games details
  // Uniqueness constraints
CREATE CONSTRAINT ON (g:GAME_ID) ASSERT g.id IS UNIQUE;
CREATE CONSTRAINT ON (p:PLAYER_ID) ASSERT p.id IS UNIQUE;
CREATE CONSTRAINT ON (t:TEAM_ID) ASSERT t.id IS UNIQUE;
  // load
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'file:///games_details.csv' AS line

MATCH (game:GAME_ID {id: ToInteger(line.GAME_ID) })
MATCH (team:TEAM_ID {id: ToInteger(line.TEAM_ID) })
MATCH (player:PLAYER_ID {id: ToInteger(line.PLAYER_ID) })
MATCH (abbreviation:ABBREVIATION {name: toUpper(line.TEAM_ABREVIATION) })
MATCH (city:CITY {name: toUpper(line.TEAM_CITY) })
MATCH (playerName:PLAYER_NAME {name: toUpper(line.PLAYER_NAME) })

// comment on specific player on the specific game
MERGE (player)-[:START_POS]->(p:START_POSITION {start_pos: coalesce(toString(line.START_POSITION), '-') })<-[:IN_GAME_POS]-(game)
MERGE (player)-[:COMMENT]->(c:COMMENT {did_play: coalesce(toString(line.COMMENT), '-') })<-[:IN_GAME]-(game)
MERGE (player)-[:MIN_PLAY]->(c:MIN {min_play: coalesce(toString(line.MIN), '-') })<-[:IN_GAME_MIN]-(game)
MERGE (player)-[:FG_MADE]->(fgm:FGM {fg_made: coalesce(ToInteger(line.FGM), 0) })<-[:IN_GAME_FGM]-(game)
MERGE (player)-[:FG_ATTEMPTED]->(fga:FGA {fg_attempted: coalesce(toString(line.FGA), 0) })<-[:IN_GAME_FGA]-(game)
MERGE (player)-[:FG_PCT]->(fgP:FG_PCT {fg_pct: coalesce(toFloat(line.FG_PCT), 0.0) })<-[:IN_GAME_FG_PCT]-(game)
MERGE (player)-[:THREE_MADE]->(fg3M:FG3M {fg3_made: coalesce(ToInteger(line.FG3M), 0) })<-[:IN_GAME_FG3M]-(game)
MERGE (player)-[:THREE_ATTEMPTED]->(fg3A:FG3A {fg3_attempted: coalesce(ToInteger(line.FG3A), 0) })<-[:IN_GAME_FG3A]-(game)
MERGE (player)-[:THREE_PCT]->(fg3P:FG3_PCT {fg3_pct: coalesce(toFloat(line.FG3_PCT), 0.0) })<-[:IN_GAME_3PCT]-(game)
MERGE (player)-[:FT_MADE]->(ftM:FTM {ft_made: coalesce(ToInteger(line.FTM), 0) })<-[:IN_GAME_FTM]-(game)
MERGE (player)-[:FT_ATTEMPTED]->(ftA:FTA {ft_attempted: coalesce(ToInteger(line.FTA), 0) })<-[:IN_GAME_FTA]-(game)
MERGE (player)-[:FT_PCT]->(ftP:FT_PCT {ft_pct: coalesce(toFloat(line.FT_PCT), 0.0) })<-[:IN_GAME_FTP]-(game)
MERGE (player)-[:OFF_REB]->(oreb:OREB {off_reb: coalesce(ToInteger(line.OREB), 0) })<-[:IN_GAME_OREB]-(game)
MERGE (player)-[:DEF_REB]->(dreb:DREB {def_reb: coalesce(ToInteger(line.DREB), 0) })<-[:IN_GAME_DREB]-(game)
MERGE (player)-[:TOTAL_REB]->(reb:REB {tot_reb: coalesce(ToInteger(line.REB), 0) })<-[:IN_GAME_REB]-(game)
MERGE (player)-[:ASSISTS]->(ast:AST {assist: coalesce(ToInteger(line.AST), 0) })<-[:IN_GAME_AST]-(game)
MERGE (player)-[:STEALS]->(stl:STL {steals: coalesce(ToInteger(line.STL), 0) })<-[:IN_GAME_STL]-(game)
MERGE (player)-[:BLOCKS]->(blk:BLK {blocks: coalesce(ToInteger(line.BLK), 0) })<-[:IN_GAME_BLK]-(game)
MERGE (player)-[:TURNOVERS]->(to:TO {turnovers: coalesce(ToInteger(line.TO), 0) })<-[:IN_GAME_TO]-(game)
MERGE (player)-[:PERSONAL_FOUL]->(pf:PF {personal_foul: ToInteger(ToInteger(line.PF), 0) })<-[:IN_GAME_PF]-(game)
MERGE (player)-[:POINTS]->(pts:PTS {points: coalesce(ToInteger(line.PTS), 0) })<-[:IN_GAME_PTS]-(game)
MERGE (player)-[:PLUS_MINUS]->(pm:PLUS_MINUS {plus_minus: coalesce(ToInteger(line.PLUS_MINUS), 0) })<-[:IN_GAME_PM]-(game)

;
