for f in segments/* ; do
 export file=$(echo "file://"`pwd`"/"$f)
 echo "Loading $file"
 cat 02-load.cypher | envsubst | cypher-shell

 if [ $? -ne 0 ] ; then
    exit 1
 fi
done
