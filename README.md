1. 启动 apollo-configservice，需要指定 eureka server 和 ApolloConfigDB，由于 apollo-configservice 内置了 eureka server，可指定为本地。启动参数见：apollo-configservice\src\main\resources\vm.properties。

```properties
-Deureka.service.url=http://localhost:8080/eureka/
-Dlogging.file.name=./apollo-configservice.log
-Dspring.datasource.url=jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8&serverTimezone=Asia/Shanghai
-Dspring.datasource.username=root
-Dspring.datasource.password=root
```

2. 启动 apollo-adminservice，需要指定 eureka server 和 ApolloConfigDB。启动参数见：apollo-adminservice\src\main\resources\vm.properties

```properties
-Deureka.service.url=http://localhost:8080/eureka/
-Dlogging.file.name=./apollo-adminservice.log
-Dspring.datasource.url=jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8&serverTimezone=Asia/Shanghai
-Dspring.datasource.username=root
-Dspring.datasource.password=root
```

3. 启动 apollo-portal，需要指定 Meta Server（其实就是 config server 的地址，一般可以替代为 slb 的地址）和 ApolloPortalDB，多环境则配置多个 meta，注意还要修改 ApolloPortalDB.serverconfig 的apollo.portal.envs，多环境才会生效。启动参数见：apollo-portal\src\main\resources\vm.properties。

```properties
-Ddev_meta=http://localhost:8080
-Dpro_meta=http://myserver:8080
-Dspring.profiles.active=github,auth
-Deureka.client.enabled=false
-Dhibernate.query.plan_cache_max_size=192
-Dlogging.file.name=./apollo-portal.log
-Dserver.port=8070 -Dspring.datasource.url=jdbc:mysql://localhost:3306/ApolloPortalDB?characterEncoding=utf8&serverTimezone=Asia/Shanghai
-Dspring.datasource.username=root
-Dspring.datasource.password=root
```

4. 启动 apollo-demo（测试 client），需要指定 Meta Server 和 appId，如果配置了 cluster 和 namespace 则需要添加 cluster 和 namespace（多个逗号分隔）。启动参数见：apollo-demo\src\main\resources\vm.properties

```properties
-Dapp.id=SampleApp
-Dapollo.meta=http://localhost:8080
-Denv=DEV
-Dapollo.cluster=default
-Dapollo.namespace=application
```

![overall-architecture](https://raw.githubusercontent.com/ctripcorp/apollo/master/doc/images/overall-architecture.png)