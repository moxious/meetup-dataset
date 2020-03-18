MATCH (a:City)-[:IN]->(ca:Country), (b:City)-[:IN]->(cb:Country)
WHERE id(a) < id(b)
AND distance(a.location, b.location) < 10000
WITH a, b, ca, cb
MERGE (ca)-[:NEIGHBOR]->(cb)
MERGE (a)-[r:hop { distance: distance(a.location, b.location) }]->(b)
RETURN count(r);