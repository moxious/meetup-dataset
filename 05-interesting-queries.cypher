/* 
 * Future Richmond Meetups within 10 miles of downtown
 */
WITH 
    point({ latitude: 37.5407246, longitude: -77.4360481 }) as RichmondVA,
    32186.9 as TenMiles   /* 10 mi expressed in meters */
MATCH (v:Venue)<-[:LOCATED_AT]-(e:Event)-[:HELD]-(g:Group) 
WHERE 
   distance(v.location, RichmondVA) < TenMiles AND
   e.time > datetime()
RETURN g.name as GroupName, e.name as EventName, e.time as When, v.name as Venue limit 10;


/*
 * Let's go dancing in Manhattan on a particular day.
 */
WITH 
   point({ latitude: 40.758896, longitude: -73.985130 }) as TimesSquareManhattan,
   32186.9 as TenMiles
MATCH (v:Venue)<-[:LOCATED_AT]-(e:Event),
      (e)-[:HELD]-(g:Group),
      (g)-[:TOPIC]->(t:Topic),
      (e)<-[:EVENT]-(r:RSVP)
WHERE e.time >= datetime("2018-09-06T00:00:00Z") AND
      e.time <= datetime("2018-09-06T23:59:59Z") AND
      distance(v.location, TimesSquareManhattan) < TenMiles AND
      v.name is not null AND
      t.name =~ '(?i).*dancing.*'
RETURN 
    g.name as GroupName, 
    collect(distinct t.name) as topics, 
    e.name as EventName, 
    count(r) as RSVPs, 
    e.time as When, 
    v.name as Venue 
ORDER BY RSVPs DESC
LIMIT 100;