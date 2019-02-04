#!/bin/bash

if [ -z $NEO4J_URI ] ; then
   echo "You must set NEO4J_URI before calling this"
   exit 1
fi

cat 01-index.cypher | cypher-shell -a $NEO4J_URI
./load-all.sh $1
cat 02b-load-world-cities.cypher | cypher-shell -a $NEO4J_URI
cat 03a-link-groups-to-countries.cypher | cypher-shell -a $NEO4J_URI
cat 03b-link-venues-to-cities.cypher | cypher-shell -a $NEO4J_URI

for q in `seq 1 5` ; do 
    rm -f queryload-$q.cypher
    for i in `seq 1 10` ; do 
        cat benchmark/q$q >> queryload-$q.cypher
    done

    echo "Running queryload $q..."
    cat queryload-$q.cypher | cypher-shell -a $NEO4J_URI
done

