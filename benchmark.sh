#!/bin/bash

TAG=$(head -c 3 /dev/urandom | md5 | head -c 5)
LOG=log-benchmark-$TAG.log

echo "====================================================" | tee >>$LOG
echo "== BENCHMARK $TAG $1" | tee >>$LOG
echo "== START: " $(date) | tee >>$LOG
echo "====================================================" | tee >>$LOG

if [ -z $2 ] ; then 
   echo "Usage: ./benchmark.sh bolt+routing://host:7687 Neo4jPassword"
   exit 1
fi

if [ -z $1 ] ; then
   echo  "Usage: ./benchmark.sh bolt+routing://host:7687 Neo4jPassword"
   exit 1
fi

export NEO4J_URI=$1
export NEO4J_PASSWORD=$2
export NEO4J_USERNAME=neo4j

STARTTIME=$(date +%s)

cat 01-index.cypher | cypher-shell -a $NEO4J_URI | tee >>$LOG
./load-all.sh segment-files-subset.txt | tee >>$LOG
cat 02b-load-world-cities.cypher | cypher-shell -a $NEO4J_URI | tee >>$LOG
cat 03a-link-groups-to-countries.cypher | cypher-shell -a $NEO4J_URI | tee >>$LOG
cat 03b-link-venues-to-cities.cypher | cypher-shell -a $NEO4J_URI | tee >>$LOG

for q in `seq 1 5` ; do 
    rm -f queryload-$q.cypher
    for i in `seq 1 10` ; do 
        cat benchmark/q$q >> queryload-$TAG-$q.cypher
    done

    echo "Running queryload $q..." | tee >>$LOG
    cat queryload-$TAG-$q.cypher | cypher-shell -a $NEO4J_URI | tee >>$LOG
done
ENDTIME=$(date +%s)
echo "BENCHMARK ELAPSED TIME IN SECONDS: " $(($ENDTIME - $STARTTIME))

rm -f queryload-$TAG-*.cypher
echo "Done" | tee >> $LOG

echo "====================================================" | tee >>$LOG
echo "== BENCHMARK $TAG $1" | tee >>$LOG
echo "== FINISH: " $(date) | tee >>$LOG
echo "====================================================" | tee >>$LOG
