@echo off
rem 项目jar包名
set apollo_demo_jar=apollo-demo-1.8.0.jar
rem meta_server地址
set meta_server="http://localhost:8081"

rem 兼容jar包在target目录的情况
if not exist %apollo_demo_jar% set apollo_demo_jar=target/apollo-demo-1.8.0.jar 


java ^
-cp %apollo_demo_jar% ^
-Dapp.id=SampleApp ^
-Dapollo.meta=%meta_server% ^
-Denv=dev ^
-Dapollo.cluster=application ^
com.ctrip.framework.apollo.demo.api.SimpleApolloConfigDemo

