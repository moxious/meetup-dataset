MATCH (g:Group)
WITH distinct(g.country) as countries
UNWIND countries as country
MERGE (c:Country { code: toUpper(coalesce(country, 'NULL'))})
WITH c, country
MATCH (g:Group { country: country })
CREATE (g)-[:COUNTRY]->(c);
