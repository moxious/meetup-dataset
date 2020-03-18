/**
 * TBD -- this will often OOME at the moment.
 */
// CALL apoc.periodic.iterate('
// MATCH (g1:Group)-[:TOPIC]-(t:Topic)-[:TOPIC]-(g2:Group) 
// WHERE id(g1) < id(g2) 
// WITH g1, g2, count(t) as shared
// WHERE shared > 1
// RETURN g1, g2, shared
// ', 'MERGE (g1)-[r:similarity { topics: shared }]->(g2)', 
// { batchSize: 5000, parallel: false });


CALL apoc.periodic.iterate('
MATCH (g1:Group), (g2:Group)
WHERE id(g1) < id(g2)
RETURN g1, g2',
'MATCH (g1)-[:TOPIC]-(t:Topic)-[:TOPIC]-(g2:Group)
WITH g1, g2, shared
WHERE shared >= 5
WITH g1, g2, shared
MERGE (g1)-[r:similarity { topics: shared }]->(g2)
RETURN count(r)', { batchSize: 100, parallel: false });
