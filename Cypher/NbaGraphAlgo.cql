// Graph Data science
// Similarity Algorithms
// Cosine Similarity given players name or teams name
// The similarity must be computed between the same/common ammount of nodes

// players-points from their common games
MATCH (p1:PLAYER_ID)-[:HAS_NAME]->(n1:PLAYER_NAME {name:'LEBRON JAMES'})
MATCH (p2:PLAYER_ID)-[:HAS_NAME]->(n2:PLAYER_NAME {name:'VINCE CARTER'})
MATCH (p1)-[pts1:POINTS]->(ptsLEB:PTS)<-[:IN_GAME_PTS]-(g:GAME_ID)
MATCH (p2)-[pts2:POINTS]->(ptsHAR:PTS)<-[:IN_GAME_PTS]-(g:GAME_ID)
RETURN n1.name AS player1,
       n2.name AS player2,
       gds.alpha.similarity.cosine(collect(ptsLEB.points), collect(ptsHAR.points)) AS similarity
;
// players-blocks
MATCH (p1:PLAYER_ID)-[:HAS_NAME]->(n1:PLAYER_NAME {name:'KEVIN DURANT'})
MATCH (p2:PLAYER_ID)-[:HAS_NAME]->(n2:PLAYER_NAME {name:'GIANNIS ANTETOKOUNMPO'})
MATCH (p1)-[blk1:BLOCKS]->(blkp1:BLK)<-[:IN_GAME_BLK]-(g:GAME_ID)
MATCH (p2)-[blk2:BLOCKS]->(blkp2:BLK)<-[:IN_GAME_BLK]-(g:GAME_ID)
RETURN n1.name AS player1,
       n2.name AS player2,
       gds.alpha.similarity.cosine(collect(blkp1.blocks), collect(blkp2.blocks)) AS similarity
;
// players-assists
MATCH (p1:PLAYER_ID)-[:HAS_NAME]->(n1:PLAYER_NAME {name:'LEBRON JAMES'})
MATCH (p2:PLAYER_ID)-[:HAS_NAME]->(n2:PLAYER_NAME {name:'CHRIS PAUL'})
MATCH (p1)-[:ASSISTS]->(ass1:AST)<-[:IN_GAME_AST]-(g:GAME_ID)
MATCH (p2)-[:ASSISTS]->(ass2:AST)<-[:IN_GAME_AST]-(g:GAME_ID)
RETURN n1.name AS player1,
       n2.name AS player2,
       gds.alpha.similarity.cosine(collect(ass1.assist), collect(ass2.assist)) AS similarity
;

// teams-fg percentage
MATCH (n1:NICKNAME {name:'HORNETS'})<-[:HAS_NICKNAME]-(t1:TEAM_ID)<-[:HOME_TEAM_IS]-(g:GAME_ID)-[:HAS_FG_H]->(fgh:FG_PCT_home)
MATCH (n2:NICKNAME {name:'BUCKS'})<-[:HAS_NICKNAME]-(t2:TEAM_ID)<-[:VISITOR_TEAM_IS]-(g:GAME_ID)-[:HAS_FG_A]->(fga:FG_PCT_away)
RETURN n1.name AS team1,
       n2.name AS team2,
       gds.alpha.similarity.cosine(collect(fgh.fg_pct_H), collect(fga.fg_pct_away)) AS similarity
;
//teams-fg3 pct
MATCH (n1:NICKNAME {name:'HORNETS'})<-[:HAS_NICKNAME]-(t1:TEAM_ID)<-[:HOME_TEAM_IS]-(g:GAME_ID)-[:HAS_FG3_H]->(fgh:FG3_PCT_home)
MATCH (n2:NICKNAME {name:'BUCKS'})<-[:HAS_NICKNAME]-(t2:TEAM_ID)<-[:VISITOR_TEAM_IS]-(g:GAME_ID)-[:HAS_FG3_A]->(fga:FG3_PCT_away)
RETURN n1.name AS team1,
       n2.name AS team2,
       gds.alpha.similarity.cosine(collect(fgh.fg3_pct_H), collect(fga.fg3_pct_A)) AS similarity
;

//Jacard similarity
// Similarity on how many games they played as teamates
MATCH (n1:PLAYER_NAME {name:'LEBRON JAMES'})<-[:HAS_NAME]-(p1:PLAYER_ID)-[:PLAYS_AT]->(t1:TEAM_ID)
WITH n1, COLLECT(id(t1)) AS TeamsPlayer1
MATCH (n2:PLAYER_NAME {name:'DWYANE WADE'})<-[:HAS_NAME]-(p2:PLAYER_ID)-[:PLAYS_AT]->(t2:TEAM_ID)
WITH n1, TeamsPlayer1, n2, COLLECT(id(t2)) AS TeamsPlayer2
RETURN n1.name AS player1,
       n2.name AS player2,
       gds.alpha.similarity.jaccard(TeamsPlayer1, TeamsPlayer2) AS similarity
;

// Similarity on players of teams
MATCH (n1:NICKNAME {name:'CAVALIERS'})<-[:HAS_NICKNAME]-(t1:TEAM_ID)-[:PLAYS_AT]-(p1:PLAYER_ID)
WITH n1, COLLECT(id(p1)) AS Players1
MATCH (n2:NICKNAME {name:'LAKERS'})<-[:HAS_NICKNAME]-(t2:TEAM_ID)-[:PLAYS_AT]-(p2:PLAYER_ID)
WITH n1, Players1, n2, COLLECT(id(p2)) AS Players2
RETURN n1.name AS Players1,
       n2.name AS Players2,
       gds.alpha.similarity.jaccard(Players1, Players2) AS similarity
;
