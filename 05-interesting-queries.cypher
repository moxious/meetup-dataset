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

