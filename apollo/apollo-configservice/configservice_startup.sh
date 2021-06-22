# 数据库
apollo_config_db_url="jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8&serverTimezone=Asia/Shanghai"
apollo_config_db_username=root
apollo_config_db_password=root

# eureka server地址
eureka_server_url="http://localhost:8080/eureka/v2/"

# 项目jar包名
config_service_jar=apollo-configservice-1.8.0.jar 
# 项目端口
config_service_port=8081 
# 项目日志路径
config_service_log=logs/100003171/apollo-configservice.log

# 兼容jar包在target目录的情况
if [ ! -f "$config_service_jar" ] ; then 
config_service_jar=target/apollo-configservice-1.8.0.jar 
fi

if [ ! -f "$config_service_log" ] ; then 
echo '建文件'
mkdir -p logs/100003171
touch logs/100003171/apollo-configservice.log
fi


nohup java \
-Dspring.datasource.url=$apollo_config_db_url \
-Dspring.datasource.username=$apollo_config_db_username \
-Dspring.datasource.password=$apollo_config_db_password \
-Dapollo.eureka.server.enabled=false \
-Deureka.service.url=$eureka_server_url \
-Dserver.port=$config_service_port \
-Dlogging.file.name=$config_service_log \
-Dapollo_profile=dev \
-jar $config_service_jar \
 > /dev/null 2>&1 &


tail -f $config_service_log