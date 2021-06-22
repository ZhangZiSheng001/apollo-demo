# 简介

apollo 是一款由携程团队开发的配置中心，可以实现配置的集中管理、分环境管理、即时生效等等。在这篇博客中，我们可以了解到：

1. 为什么使用配置中心
2. 如何设计一个配置中心
3. apollo 是如何设计的
4. 如何使用 apollo

# 为什么使用配置中心

这里我回答的是为什么使用配置中心，而不是为什么使用 apollo。为什么呢？因为我不建议使用 apollo，之所以研究它，只是好奇而已。另外，为什么使用配置中心，这个是需求层面的问题，需求是明确的，但实现需求的手段就不一定了。这个有点像人需要吃饭但不一定得吃馒头。

首先，我们可以想象下，如果没有配置中心，我们的项目可能是这样的：不同环境的配置文件都放在项目里面，部署时可以通过启动参数来指定使用哪个环境的配置。

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144138435-91638981.png" alt="zzs_apollo_01" style="zoom:67%;" />

这种方式有两个比较大的缺点：

1. 不安全。项目的开发人员可以看到生产环境的各种地址、账号、密码等等，这是不安全的；
2. 配置更新需要重启项目才能生效。

配置中心就是为了解决这些问题而存在的。

# 如何设计一个配置中心

## 安全

还是继续上面的分析。为了解决配置的安全问题，我们很自然地会想到把配置文件放到一个开发人员看不到的地方，即**项目和配置分离**，如图所示。这个放配置的地方可以是数据库，可以是远程文件，也可以是独立的应用，等等。

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144157151-942376681.png" alt="zzs_apollo_02" style="zoom:67%;" />

这样就能解决安全问题了吗？还是不行，项目的开发人员还是能看到生产的配置。为什么呢？因为测试环境和生产环境共用一个配置中心，开发人员能拿到测试环境的配置，也就能拿到生产环境的配置。所以，**环境不同，配置中心也不一样**（如果非要共用一个，得想好隔离方案）。

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144215397-471408427.png" alt="zzs_apollo_03" style="zoom:67%;" />

## 即时发布

接着，我们来解决第二个问题：配置的即时发布。

我们需要在客户端和配置中心之间建立某种机制，**让客户端可以感知到配置的变化**，一般可以通过以下方式实现（apollo 两种方式都用了）：

1. 客户端定时重拉配置；
2. 服务端主动推送。

还有一点需要注意，客户端拿到新的配置后，**需要让配置生效**，即把新配置注入到对应的类中，这一点在集成了 spring 的项目里会好处理一些。

那么 apollo 是如何实现的呢？我们可以关注下`com.ctrip.framework.apollo.spring.property.SpringValueRegistry`这个类，它里面存放了项目的所有配置信息，客户端感知到配置变更后，只要更新这上面的配置就行。而这个类里面的配置是通过`BeanDefinitionRegistryPostProcessor`+`BeanFactoryPostProcessor`来完成初始化的。原理并不复杂，这里就不扩展了。

## 方便管理

另外，为了更方便地管理配置，配置中心一般会有控制台。控制台有两种形式（apollo 采用第一种）：

1. 所有环境共用一个控制台（这种情况需要增加一个应用来集成各个环境的配置）；
2. 不同环境使用不同的控制台。

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144232931-397399142.png" alt="zzs_apollo_04" style="zoom:67%;" />

经过以上的分析，我们设计出了一个简单的配置中心。


# apollo是如何设计的

关于这个问题，官方给出了这样一张图。

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144251121-863563175.png" alt="zzs_apollo_05" style="zoom: 80%;" />

是不是看不懂呢？其实看不懂很正常，因为**作为一个配置中心来说，apollo 太重了**。

我们还是继续上面的分析，在雏形的基础上慢慢设计出 apollo 的结构。

首先，如果配置中心是单独的应用，配置信息放在数据库里面，它的结构大概是这样的。

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144310705-121985014.png" alt="zzs_apollo_06" style="zoom: 67%;" />

apollo 将这里的 config server 拆分成了 config service 和 admin service，前者负责与 app001交互，后者负责与 config console 交互。这一步吧，我倒是觉得可有可无。

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144345103-949535369.png" alt="zzs_apollo_07" style="zoom: 67%;" />

其实分析到这里，apollo 作为配置中心的部分已经完整的画出来了。目前为止，apollo 还算是一个中规中矩的配置中心，但是，apollo 给的东西太多了，它还提供了集群支持，官方给的图中，meta server、eureka 都属于这部分。我认为，集群的支持本意是好的，但仅仅为了支持这个功能让 apollo 变得太过庞大。

那么，要如何实现集群支持呢？其实有一个最简单的方案，就是直接通过 SLB 访问即可。

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144329863-160533910.png" alt="zzs_apollo_08" style="zoom: 67%;" />

但是人家 apollo 偏偏要用 eureka，如图所示。config service 需要先注册到 eureka server，然后 app001 要先从 eureka server 获取 config service 的地址，然后再访问。config console 和 admin service 的交互同理。

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144402062-200723399.png" alt="zzs_apollo_09" style="zoom: 67%;" />

走到这里，无非是采用 SLB 还是采用 eureka 来实现负载均衡，还是可以接受的。

但是呢？使用 eureka 来实现负载均衡的话，就要求 app001 必须引入 eureka client，但我不想引入怎么办。于是，apollo 开发团队又搞出一个新的项目 meta server 来屏蔽对 eureka 的依赖。

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144418115-174772890.png" alt="zzs_apollo_10" style="zoom: 67%;" />

我们发现，apollo 已经大得离谱了。

然而还没完，在上面的结构图中，我们会发现，meta server 如果挂了，config service 做再多集群也没用，也就是说 meta server 也需要做集群，这时应该怎么处理呢？apollo 官方给出了方案--使用 SLB。

那么，我想问，为什么不一开始就使用 SLB 呢？？

我看了官网关于这个问题的回答，之所以这么设计是为了避免客户端和 config service 之间的长连接给 SLB 增加过多的负担。当然，这种解释还是可以接受，但是不是有更好的方案呢？

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144435104-1564832386.png" alt="zzs_apollo_12" style="zoom: 67%;" />

# 如何使用apollo

## 测试方案

我把 apollo github 上的代码拉到本地重新编译打包，代码稍有改动。我的测试方案如下。

服务器 1 是我的 windows 电脑，用来模拟 dev 环境，上面部署了配置中心、eureka、数据库，客户端和 portal 也部署在这台电脑。

服务器 2 是我的 linux 服务器，用来模拟 pro 环境，上面部署了配置中心、eureka、数据库。

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144456732-151954763.png" alt="zzs_apollo_11" style="zoom:67%;" />

## 环境说明

os：服务器1：win 10，服务器2：linux

eureka：1.10.11

apollo：1.8.0

maven：3.6.3

jdk：1.8.0_231

mysql：5.7.28

## 创建数据库

在服务器 1 和服务器 2 新建数据库`ApolloPortalDB`和`ApolloConfigDB`，具体脚本为[apollo sql](https://github.com/ZhangZiSheng001/apollo-demo/tree/master/sql)。

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144514795-1599156395.png" alt="zzs_apollo_13" style="zoom:67%;" />

## 启动eureka

config service 中自带了一个 eureka server，但我不打算用，所以后面的测试中都会将它禁用掉。这里分别启动服务器 1 和服务器 2 的 eureka，端口为 8080。eureka 相关内容可以参考我的另一篇博客：[Java源码详解系列(十二)--Eureka的使用和源码](https://www.cnblogs.com/ZhangZiSheng001/p/14395203.html)。

## 启动config service和meta server

`mvn clean package`打包 config service 项目，通过批处理文件启动项目（根据操作系统选择不同的脚本），端口是 8081。config service 里面集成了 meta server，所以，这里我们同时启动了 config service 和 meta server。

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144534818-772809695.png" alt="zzs_apollo_14" style="zoom:80%;" />

## 启动admin service

`mvn clean package`打包 admin service 项目，通过批处理文件启动项目，端口是 8082。在我们的测试例子中，config service 和 admin service 谁先启动都可以，但是，如果我们使用了 config service 里的 eureka server，那么必须先启动 config service。

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144551888-949635162.png" alt="zzs_apollo_15" style="zoom:80%;" />

## 启动portal

`mvn clean package`打包 portal 项目，通过批处理文件启动项目，端口是 8083。

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144607940-885831956.png" alt="zzs_apollo_16" style="zoom:80%;" />

这个时候，我们可以通过`http://127.0.0.1:8083/`访问管理界面（账号 apollo，密码 admin）。我们可以看到实例项目 SampleApp，它的两个环境分别对应我们服务器 1 和服务器 2 的配置中心。

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144629331-1586731238.png" alt="zzs_apollo_17" style="zoom:80%;" />

## 启动apollo demo

apollo demo 用来模拟我们的实际项目，演示从配置中心获取配置，项目中需要引入 apollo-client 的依赖。

`mvn clean package`打包项目，通过批处理文件启动项目（连接的是 dev 的配置中心，可以自行修改）。当我们输入 key 为 timeout 时，可以拿到配置中心的 value 为 100。

<img src="https://img2020.cnblogs.com/blog/1731892/202106/1731892-20210622144644560-1557933338.png" alt="zzs_apollo_18" style="zoom:80%;" />

走到这里，我们成功地完成了 apollo 的部署。

以上基本讲完了 apollo 的结构和使用。如有错误，欢迎指正。

最后，感谢阅读。

# 参考资料

[apollo官方文档](https://www.apolloconfig.com/#/zh/README)

> 相关源码请移步：https://github.com/ZhangZiSheng001/apollo-demo

> 本文为原创文章，转载请附上原文出处链接：https://www.cnblogs.com/ZhangZiSheng001/p/14918588.html