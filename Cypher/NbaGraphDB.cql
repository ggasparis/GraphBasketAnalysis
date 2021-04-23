  // Uniqueness constraints
CREATE CONSTRAINT ON (g:GAME_ID) ASSERT g.id IS UNIQUE;
CREATE CONSTRAINT ON (p:PLAYER_ID) ASSERT p.id IS UNIQUE;
CREATE CONSTRAINT ON (t:TEAM_ID) ASSERT t.id IS UNIQUE;
  // load
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'file:///games_details.csv' AS line

CREATE (game:GAME_ID {id: ToInteger(line.GAME_ID) })
CREATE (team:TEAM_ID {id: ToInteger(line.TEAM_ID) })
CREATE (player:PLAYER_ID {id: ToInteger(line.PLAYER_ID) })

MERGE (abbreviation:TEAM_ABBREVIATION {name: toUpper(line.TEAM_ABREVIATION) })
MERGE (city:TEAM_CITY {name: toUpper(line.TEAM_CITY) })
MERGE (playerName:PLAYER_NAME {name: toUpper(line.PLAYER_NAME) })
MERGE (min:MIN {name: line.MIN
MERGE (FieldGoalMade:FGM {name: line.FGM})

CREATE (team)-[t:IN]->(city)
CREATE (team)-[t:HAS]->(dTeam)

CREATE (player)-[p:HAS]->(playerName)
CREATE (player)-[p:HAS]->(playerName)

;

CREATE CONSTRAINT ON (p:PLAYER_ID) ASSERT p.id IS UNIQUE;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS
FROM 'file:///players.csv' AS line

MATCH (team:TEAM_ID {id: ToInteger(line.TEAM_ID) })

CREATE (player:PLAYER_ID {id: ToInteger(line.PLAYER_ID) })

MERGE (playerName:PLAYER_NAME {name: toUpper(line.PLAYER_NAME) })
MERGE (season:SEASON {name: ToInteger(line.SEASON) })
MERGE ()

CREATE (player)-[:PLAYS_AT]->(team)
CREATE (playerName)-[:PLAYS_TO]->(city)

;
