@echo off
rem 数据库
set apollo_config_db_url="jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8&serverTimezone=Asia/Shanghai" 
set apollo_config_db_username=root 
set apollo_config_db_password=root 

rem eureka server地址
set eureka_server_url="http://127.0.0.1:8080/eureka/v2/" 

rem 项目jar包名
set admin_service_jar=apollo-adminservice-1.8.0.jar 
rem 项目端口
set admin_service_port=8082 
rem 项目日志路径
set admin_service_log=logs/100003172/apollo-adminservice.log

rem 兼容jar包在target目录的情况
if not exist %admin_service_jar% set admin_service_jar=target/apollo-adminservice-1.8.0.jar 

java ^
-Dspring.datasource.url=%apollo_config_db_url% ^
-Dspring.datasource.username=%apollo_config_db_username% ^
-Dspring.datasource.password=%apollo_config_db_password% ^
-Deureka.service.url=%eureka_server_url% ^
-Deureka.client.fetchRegistry=false ^
-Dserver.port=%admin_service_port% ^
-Dlogging.file.name=%admin_service_log% ^
-Dapollo_profile=dev ^
-jar %admin_service_jar% 
