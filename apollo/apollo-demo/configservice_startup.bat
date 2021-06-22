@echo off
rem 数据库
set apollo_config_db_url="jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8&serverTimezone=Asia/Shanghai" 
set apollo_config_db_username=root 
set apollo_config_db_password=root 

rem eureka server地址
set eureka_server_url="http://127.0.0.1:8080/eureka/v2/" 

rem 项目jar包名
set config_service_jar=apollo-configservice-1.8.0.jar 
rem 项目端口
set config_service_port=8081 
rem 项目日志路径
set config_service_log=logs/100003171/apollo-configservice.log

rem 兼容jar包在target目录的情况
if not exist %config_service_jar% set config_service_jar=target/apollo-configservice-1.8.0.jar 

java ^
-Dspring.datasource.url=%apollo_config_db_url% ^
-Dspring.datasource.username=%apollo_config_db_username% ^
-Dspring.datasource.password=%apollo_config_db_password% ^
-Dapollo.eureka.server.enabled=false ^
-Deureka.service.url=%eureka_server_url% ^
-Dserver.port=%config_service_port% ^
-Dlogging.file.name=%config_service_log% ^
-Dapollo_profile=dev ^
-jar %config_service_jar% 
