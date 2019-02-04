#!/bin/bash

TAG=$(head -c 3 /dev/urandom | md5 | head -c 5)
LOG=log-benchmark-$TAG.log

echo "Benchmark $TAG starting, logging to $LOG"
echo "====================================================" | tee $LOG
echo "== BENCHMARK $TAG $1" | tee $LOG
echo "== START: " $(date) | tee $LOG
echo "====================================================" | tee $LOG

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

echo "Index phase" | tee $LOG
cat 01-index.cypher | cypher-shell -a $NEO4J_URI >>$LOG
echo "Load phase" | tee $LOG
./load-all.sh segment-files-subset.txt >>$LOG
echo "Cities phase" | tee $LOG
cat 02b-load-world-cities.cypher | cypher-shell -a $NEO4J_URI >>$LOG
echo "Link groups phase" | tee $LOG
cat 03a-link-groups-to-countries.cypher | cypher-shell -a $NEO4J_URI >>$LOG
echo "Link venues phase" | tee $LOG
cat 03b-link-venues-to-cities.cypher | cypher-shell -a $NEO4J_URI >>$LOG

for q in `seq 1 5` ; do 
    echo "Queryload $q phase" | tee $LOG
    for i in `seq 1 10` ; do 
        cat benchmark/q$q >> queryload-$TAG-$q.cypher
    done

    cat queryload-$TAG-$q.cypher | cypher-shell -a $NEO4J_URI >>$LOG
done
ENDTIME=$(date +%s)
ELAPSED=$(($ENDTIME - $STARTTIME))
echo "BENCHMARK ELAPSED TIME IN SECONDS: " $ELAPSED | tee $LOG

rm -f queryload-$TAG-*.cypher
echo "Done" | tee $LOG

echo "====================================================" >>$LOG
echo "== BENCHMARK $TAG $1" | tee >>$LOG
echo "== FINISH: " $(date) | tee >>$LOG
echo "====================================================" >>$LOG
echo "Benchmark $TAG complete with $ELAPSED elapsed; logging to $LOG" | tee $LOG