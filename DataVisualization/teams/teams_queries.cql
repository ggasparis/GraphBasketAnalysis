CREATE CONSTRAINT ON (t:TEAM_ID) ASSERT t.id IS UNIQUE;
CREATE CONSTRAINT ON (c:CITY) ASSERT c.name IS UNIQUE;
CREATE CONSTRAINT ON (r:ARENA) ASSERT r.name IS UNIQUE;



USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM
'file:///teams.csv' AS line


CREATE (team:TEAM_ID {id: ToInteger(line.TEAM_ID) })

MERGE (city:CITY {name: toUpper(line.CITY) })
MERGE (arena:ARENA {name: toUpper(line.ARENA)})
MERGE (dTeam:DLEAGUEAFFILIATION {name: toUpper(line.DLEAGUEAFFILIATION)})

CREATE (team)-[:IN]->(city)
CREATE (team)-[:TO]->(arena)
CREATE (team)-[:HAS]->(dTeam)

CREATE (dTeam)-[d:HAS]->(team)
SET d.dleague = CASE line.DLEAGUEAFFILIATION WHEN 'No Affiliate' THEN true ELSE false END

;
