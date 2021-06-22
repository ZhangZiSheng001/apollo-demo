pids=`ps -ef | grep java|grep apollo-adminservice|awk '{print $2}'`
for id in $pids
do
kill -9 $id
echo "killed $id"
done