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

// teams-wins percentage
MATCH (t1:TEAM_ID)-[:HAS_NICKNAME]-(n1:NICKNAME {name:'LAKERS'})
MATCH (t2:TEAM_ID)-[:HAS_NICKNAME]-(n2:NICKNAME {name:'CELTICS'})
MATCH (t1)-[wp1:TOTAL_WINS_PCT]->(twp1:W_PCT)
MATCH (t1)-[:RECORD_DATE]->(s:STANDINGSDATE)
MATCH (t2)-[wp2:TOTAL_WINS_PCT]->(twp2:W_PCT)
MATCH (t2)-[:RECORD_DATE]->(s:STANDINGSDATE)

RETURN n1.name AS team1,
       n2.name AS team2,
       gds.alpha.similarity.cosine(collect(twp1.win_pct), collect(twp2.win_pct)) AS similarity
;
