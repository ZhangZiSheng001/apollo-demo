@echo off
rem 数据库地址
set apollo_portal_db_url="jdbc:mysql://localhost:3306/ApolloPortalDB?characterEncoding=utf8&serverTimezone=Asia/Shanghai" 
rem 数据库用户名
set apollo_portal_db_username=root 
rem 数据库密码
set apollo_portal_db_password=root 
rem 项目jar包名
set portal_jar=apollo-portal-1.8.0.jar 
rem 项目端口
set portal_port=8083 
rem 项目日志路径
set portal_log=logs/100003173/apollo-portal.log
rem 分哪几个环境
set portal_envs=dev,pro
rem meta_server地址
set meta_server_dev="http://localhost:8081"
set meta_server_pro="http://zzs_server:8081"

rem 兼容jar包在target目录的情况
if not exist %portal_jar% set portal_jar=target/apollo-portal-1.8.0.jar 

java ^
-Dapollo.portal.envs=%portal_envs% ^
-Ddev_meta=%meta_server_dev% ^
-Dpro_meta=%meta_server_pro% ^
-Dspring.datasource.url=%apollo_portal_db_url% ^
-Dspring.datasource.username=%apollo_portal_db_username% ^
-Dspring.datasource.password=%apollo_portal_db_password% ^
-Dserver.port=%portal_port% ^
-Dlogging.file.name=%portal_log% ^
-Dapollo_profile=dev ^
-jar %portal_jar% 