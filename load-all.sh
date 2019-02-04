cat 01-index.cypher | cypher-shell

for f in $(cat segment-files.txt) ; do
 export file=$f
 echo "Loading $file"
 cat 02-load.cypher | envsubst | cypher-shell

 if [ $? -ne 0 ] ; then
    exit 1
 fi
done
