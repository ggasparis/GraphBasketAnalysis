// Queries for stats - extract info

//Q1 Teams that the player has played given player's name
MATCH (m:PLAYER_NAME {name:'LEBRON JAMES'})
MATCH (p:PLAYER_ID)-[:HAS_NAME]->(m)
MATCH (t:TEAM_ID)-[:HAS_NICKNAME]->(n:NICKNAME)
MATCH (p)-[:PLAYS_AT]->(t)
RETURN n AS teams
;
//Q2 Team's players from all seasons
MATCH (n:NICKNAME {name:'HAWKS'})
MATCH (t:TEAM_ID)-[:HAS_NICKNAME]->(n)
MATCH (p:PLAYER_ID)-[:HAS_NAME]->(m:PLAYER_NAME)
MATCH (p)-[:PLAYS_AT]->(t)
RETURN m
;
//Q3 Team's players for every season and how many times they played
MATCH (p:PLAYER_ID)-[:PLAYS_AT]->(t:TEAM_ID)-[:HAS_NICKNAME]->(n:NICKNAME {name:'HAWKS'})
MATCH (p:PLAYER_ID)-[:PLAYED_IN_SEASON]->(s:SEASON)
MATCH (p)-[:HAS_NAME]->(m:PLAYER_NAME)
RETURN m AS player,
       s AS season,
       COUNT(p) AS count
;
//Q4 Home teams on this date
MATCH (g:GAME_ID)-[:ON_DATE]->(d:GAME_DATE_EST)
WHERE d.date = date({year: 2020, month: 03, day: 01})
MATCH (g)-[:HOME_TEAM_IS]->(t:TEAM_ID)-[:HAS_NICKNAME]->(n:NICKNAME)
RETURN n
;
//Q5 Head coach of the team
MATCH (n:NICKNAME {name:'MAVERICKS'})
MATCH (t:TEAM_ID)-[:HAS_NICKNAME]->(n)
MATCH (t)-[:COACHED_BY]->(h)
RETURN h
;
//Q6 Team's average FG3 pct
MATCH (g:GAME_ID)-[:TEAM_HOME]->(t:TEAM_ID)-[:HAS_NICKNAME]->(n:NICKNAME {name:'NUGGETS'})
MATCH (g)-[:HAS_FG3_H]->(fg:FG3_PCT_home)
RETURN n AS team,
      AVG(fg.fg3_pct_H) AS fg3
;
//Q7 Player's average fg pct
MATCH (p:PLAYER_ID)-[:HAS_NAME]-(m:PLAYER_NAME)
WHERE m.name = 'CHRIS PAUL'
MATCH (p)-[:FG_ATTEMPTED]->(fga:FGA)
MATCH (p)-[:FG_PCT]->(fg:FG_PCT)
RETURN m,
       AVG(fg.fg_pct) AS shots,
       AVG(fga.fg_attempted) AS attempted,
       SUM(fga.fg_attempted) AS total
;
//Q8 How many times coach deside not to play
MATCH (p:PLAYER_ID)-[:COMMENT]->(c:COMMENT)<-[:IN_GAME]-(g:GAME_ID)
WHERE c.did_play <>  '-'
MATCH (p:PLAYER_ID)-[:HAS_NAME]-(m:PLAYER_NAME {name:'THANASIS ANTETOKOUNMPO'})
RETURN m AS player,
      COUNT(c) AS count
;
//Q9 Poioi exoun faei polu pago
MATCH (p:PLAYER_ID)-[:COMMENT]->(c:COMMENT)<-[:IN_GAME]-(g:GAME_ID)
WHERE c.did_play <>  '-'
MATCH (p:PLAYER_ID)-[:HAS_NAME]-(m:PLAYER_NAME)
RETURN m AS player,
      COUNT(c) AS count
ORDER BY count DESC
LIMIT 10
;
//Q10 Top 10 players with the most points
MATCH (p:PLAYER_ID)-[:POINTS]->(n:PTS)<-[:IN_GAME_PTS]-(g:GAME_ID)
MATCH (p)-[:HAS_NAME]->(m:PLAYER_NAME)
RETURN m AS player,
      SUM(n.points) AS points
ORDER BY points DESC
LIMIT 10
;
//Q11 Game date based on game_id
MATCH (g:GAME_ID)-[:ON_DATE]->(d:GAME_DATE_EST)
WHERE g.id = 21900895
RETURN d
;
// Show the teams matches given the date
MATCH (g:GAME_ID)-[:ON_DATE]->(d:GAME_DATE_EST)
WHERE d.date = date({year: 2020, month: 03, day: 01})
MATCH (g)-[:TEAM_HOME]->(t1:TEAM_ID)
MATCH (g)-[:TEAM_AWAY]->(t2:TEAM_ID)
MATCH (t1)-[:HAS_NICKNAME]-(n1:NICKNAME)
MATCH (t2)-[:HAS_NICKNAME]-(n2:NICKNAME)
RETURN COLLECT(n1.name) AS HomeTeams,
       COLLECT(n2.name) AS AwayTeams
;
//Q12 Game_id based on date
MATCH (g:GAME_ID)-[:ON_DATE]->(d:GAME_DATE_EST)
WHERE d.date = date({year: 2020, month: 03, day: 01})
RETURN g AS gameID
;
//Q13 Find home team from game_id
MATCH (g)-[:HOME_TEAM_IS]->(t:TEAM_ID)
WHERE g.id = 21900895
MATCH (t)-[:HAS_NICKNAME]->(n:NICKNAME)
RETURN n
;
//Q14 Find away team from game_id
MATCH (g:GAME_ID)-[:TEAM_AWAY]->(t:TEAM_ID)
WHERE g.id = 21900895
MATCH (t)-[:HAS_NICKNAME]->(n:NICKNAME)
RETURN n
;
//Q15 Top 10 players with the most transfers
MATCH (p:PLAYER_ID)-[:HAS_NAME]->(m:PLAYER_NAME)
RETURN m AS player, COUNT(p) AS count
ORDER BY count DESC
LIMIT 10
;
// Game appereances
MATCH (p:PLAYER_ID)-[:COMMENT]->(c:COMMENT)<-[:IN_GAME]-(g:GAME_ID)
WHERE c.did_play = '-'
MATCH (p)-[:HAS_NAME]->(m:PLAYER_NAME)
RETURN m AS player,
       COUNT(p) AS count
ORDER BY count DESC
LIMIT 10
;
// Who did not play 
MATCH (p:PLAYER_ID)-[:COMMENT]->(c:COMMENT)<-[:IN_GAME]-(g:GAME_ID)
WHERE c.did_play <> '-'
MATCH (p)-[:HAS_NAME]->(m:PLAYER_NAME)
RETURN m AS player,
       c AS reason,
       COUNT(p) AS count
ORDER BY count DESC
LIMIT 25
;
//Q16 Top 5 players with most start positions
MATCH (p:PLAYER_ID)-[:START_POS]->(s:START_POSITION)
WHERE s.start_pos <> '-'
MATCH (p)-[:HAS_NAME]->(m:PLAYER_NAME)
RETURN m AS player,
       COUNT(p) AS count
ORDER BY count DESC
LIMIT 5
;
//Q17 Top 10 players based on +/-
MATCH (p:PLAYER_ID)-[:PLUS_MINUS]->(l:PLUS_MINUS)<-[:IN_GAME_PM]-(g:GAME_ID)
WHERE l.plus_minus <> 0
MATCH (p)-[:HAS_NAME]->(m:PLAYER_NAME)
RETURN m AS player,
  AVG(l.pm) AS pm
ORDER BY pm DESC
LIMIT 10
;
//Q18 Top 10 rebs players
MATCH (p:PLAYER_ID)-[:TOTAL_REB]->(n:REB)<-[:IN_GAME_REB]-(g:GAME_ID)
MATCH (p)-[:HAS_NAME]->(m:PLAYER_NAME)
RETURN m AS player,
      SUM(n.tot_reb) AS rebs
ORDER BY rebs DESC
LIMIT 10
;
//Q19 Top 10 assists
MATCH (p:PLAYER_ID)-[:ASSISTS]->(n:AST)<-[:IN_GAME_AST]-(g:GAME_ID)
MATCH (p)-[:HAS_NAME]->(m:PLAYER_NAME)
RETURN m AS player,
      SUM(n.ast) AS ast
ORDER BY ast DESC
LIMIT 10
;
//Q20 Top 10 blocks
MATCH (p:PLAYER_ID)-[:BLOCKS]->(n:BLK)<-[:IN_GAME_BLK]-(g:GAME_ID)
MATCH (p)-[:HAS_NAME]->(m:PLAYER_NAME)
RETURN m AS player,
      SUM(n.blocks) AS blk
ORDER BY blk DESC
LIMIT 10
;
//Q21 Count players total POINTS
MATCH (p:PLAYER_ID)-[:POINTS]->(n:PTS)<-[:IN_GAME_PTS]-(g:GAME_ID)
MATCH (p)-[:HAS_NAME]->(m:PLAYER_NAME)
RETURN m AS player,
      SUM(n.points) AS points
ORDER BY points DESC
LIMIT 10
;
//Q22 Average points
MATCH (p:PLAYER_ID)-[:POINTS]->(n:PTS)<-[:IN_GAME_PTS]-(g:GAME_ID)
MATCH (p)-[:HAS_NAME]->(m:PLAYER_NAME)
RETURN m AS player,
      AVG(n.points) AS points
ORDER BY points DESC
LIMIT 10
;
//Q23 Most appereances in G position
MATCH (p:PLAYER_ID)-[:START_POS]->(s:START_POSITION)
WHERE s.start_pos = 'G'
MATCH (p)-[:HAS_NAME]->(m:PLAYER_NAME)
RETURN m AS player,
       COUNT(p) AS count
ORDER BY count DESC
LIMIT 5
;
//Q24 game status
MATCH (d:GAME_DATE_EST)<-[:ON_DATE]-(g:GAME_ID)-[:GAME_STATUS_IS]->(gs:GAME_STATUS_TEXT)
WHERE gs.game_satus <> 'FINAL'
RETURN d AS date,
       COUNT(g) AS count
;
