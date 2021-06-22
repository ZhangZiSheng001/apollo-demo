pids=`ps -ef | grep java|grep apollo-configservice|awk '{print $2}'`
for id in $pids
do
kill -9 $id
echo "killed $id"
done