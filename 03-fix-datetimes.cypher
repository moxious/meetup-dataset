
/* Update times */
CALL apoc.periodic.iterate(
    "MATCH (e:Event) WHERE e.time IS NOT NULL RETURN e",
    "SET e.time = datetime({ epochMillis: e.time })",
    { batchSize: 10000 })
YIELD batches, total
RETURN batches, total;

CALL apoc.periodic.iterate(
    "MATCH (r:RSVP) WHERE r.mtime IS NOT NULL RETURN r",
    "SET r.mtime = datetime({ epochMillis: r.mtime })",
    { batchSize: 10000 })
YIELD batches, total
RETURN batches, total;
