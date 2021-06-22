# 数据库
apollo_config_db_url="jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8&serverTimezone=Asia/Shanghai"
apollo_config_db_username=root
apollo_config_db_password=root

# eureka server地址
eureka_server_url="http://localhost:8080/eureka/v2/"

# 项目jar包名
admin_service_jar=apollo-adminservice-1.8.0.jar 
# 项目端口
admin_service_port=8082 
# 项目日志路径
admin_service_log=logs/100003172/apollo-adminservice.log

# 兼容jar包在target目录的情况
if [ ! -f "$admin_service_jar" ] ; then 
admin_service_jar=target/apollo-adminservice-1.8.0.jar 
fi

if [ ! -f "$admin_service_log" ] ; then 
mkdir -p logs/100003172
touch logs/100003172/apollo-adminservice.log
fi


nohup java \
-Dspring.datasource.url=$apollo_config_db_url \
-Dspring.datasource.username=$apollo_config_db_username \
-Dspring.datasource.password=$apollo_config_db_password \
-Deureka.service.url=$eureka_server_url \
-Deureka.client.fetchRegistry=false \
-Dserver.port=$admin_service_port \
-Dlogging.file.name=$admin_service_log \
-Dapollo_profile=dev \
-jar $admin_service_jar \
 > /dev/null 2>&1 &


tail -f $admin_service_log