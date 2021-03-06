---
layout: post
title:  "手把手教你用新浪云容器 Java 搭建自己的网站"
date:   2016-09-20 16:32:01
---

经过一段时间的开发，更新，迭代，新浪云容器 Java 环境逐渐成熟起来，相比过去的 Java 运行环境，可用性和易用性都得到了大量的提升。同时也收到了不少用户反馈的使用问题，特此在这篇文章里综合介绍一下容器 Java 使用以及相关服务的整合。


**环境说明**

新浪云容器 Java 环境基于 Docker 搭建，支持多实例负载均衡，近乎原生虚拟机环境，使用无门槛。

* JDK 1.8
* Web 容器 tomcat-8.0.35

*注意：这里以后可能会提供相应的 Web 容器定制服务*


**准备**

开发自己的应用之前，我们先要准备好自己的开发环境，新浪云的容器 Java 应用所需的环境和一般开发环境类似。

* JDK（最好是能与线上同步，当然低版本也可以） version:1.7 以上
* 开发 IDE（推荐 eclipse，有相应的开发插件，能够快速上传） version:eclipse(Mars.1 Release (4.5.1) 此版本自带了 maven 插件，不需要另装了）
* maven（推荐使用，能够方便使用新浪云提供的 sdk） version:3.3.9

*安装方式就不累述了，各个环境下如何安装配置，大家可以自行用百度谷歌一下*

**创建初始化应用**


首先我们要创建自己的新浪云账号，这个就不累述了，具体参看[新浪云](http://www.sinacloud.com/)。

然后我们来着手建立一个 maven 的项目，当然我们可以通过 maven 的命令来创建一个项目，不过我们有 IDE，可以方便的利用可视化界面操作，而且也方便使用插件。

好了，我们打开 Eclipse，接下来我们就开始创建自己的 Web 项目，点击"File"->"New"->"Maven project"，如下图

![create-project]({{ site.url }}/assets/eclipse-create-mvn-01.png)

然后点击"Next"，注意接下来选择的"Archetype"，咱们是 Web 项目，所以一定要选择"maven-archetype-webapp"，如下图

![create-project]({{ site.url }}/assets/eclipse-create-mvn-02.png)

然后点击"Next"，填写 Group Id 和 Artifact Id，然后在点击"Finish"。

![create-project]({{ site.url }}/assets/eclipse-create-mvn-03.png)

然后咱们的项目就建好了，目录结构如下图，接下来我们就开始开发我们自己的项目

![create-project]({{ site.url }}/assets/eclipse-create-mvn-04.png)

首先我们建立一下源码目录，在 src->main 下面新建一个文件夹 java，然后就可以看到如图的应用结构了

![create-project]({{ site.url }}/assets/eclipse-create-mvn-05.png)

这里还有一个注意的地方，建立好新的 maven 项目之后，可能需要一些简单的配置，如果默认配置好了可以忽略了，主要注意两个方面的配置，一是 Servlet 版本，一是 JDK 版本，以及项目结构。

改下 JDK，点击项目右键 ->proerties->java compile，如下图

![create-project]({{ site.url }}/assets/change-eclipse-config-01.png)

将 JDK 版本调整为 1.7 以上以匹配线上版本。

在修改下项目的结构，如下图。点击 Project Facet，修改下 Java 的版本和刚刚修改的版本一致。

![create-project]({{ site.url }}/assets/change-eclipse-config-02.png)

修改下 Dynamic Web Module，改成 3.1 版本（如果点击下面提示无法改变版本的话，就先反选 Dynamic Web Module 然后确定，在重新进入这个界面在勾选即可修改）。如下图

![create-project]({{ site.url }}/assets/change-eclipse-config-03.png)

注意图中的标注位置，点击进去，配置一下 Web 目录，如下图

![create-project]({{ site.url }}/assets/change-eclipse-config-04.png)

将我们建立项目的 Web 目录配置下。

最后，我们在来安装下新浪云的 Eclipse 插件，具体安装的方法参见[使用 Eclipse 插件部署 Java 应用](http://www.sinacloud.com/doc/sae/docker/java-eclipse-plugin.html)。

至此，我们开发前的准备工作就完成了，接下来我们可以开始开发了。



接下来的 Web 应用就可以根据自己的业务需求开始开发，就不说具体的开发过程了，下面着重介绍下新浪云相关服务的使用方法和注意事项。
我们先来建立一个 Servlet，通过这个 Servlet 来演示相关功能的展示，建立一个如下图的 package 在建立一个名为 test 的 Servlet。

![create-servlet]({{ site.url }}/assets/start-create-servlet.png)

然后可以通过 Eclipse 插件将应用上传到新浪云，插件使用见[使用 Eclipse 插件部署 Java 应用](http://www.sinacloud.com/doc/sae/docker/java-eclipse-plugin.html)，也就是你刚刚创建的应用，注意填写相关的信息。部署时间大约为 3 分钟，然后可以在浏览器里访问我们创建的 servlet 了，如下图。

![create-servlet]({{ site.url }}/assets/show-servlet.png)

这样，我们的 Servlet 的就建立好了，接下来我们的演示就基于这个 Servlet 展开介绍。

**MySQL**

新浪云的数据库服务有两种，一种是[共享型数据库](http://www.sinacloud.com/doc/sae/php/mysql.html)，一种是[独享型数据库](http://www.sinacloud.com/doc/sae/php/rds.html)，但其实操作方式都是一样的，具体参看相关文档。以共享型数据库为例子吧，通过 jdbc 方式即可连接。

首先，在新浪云控制面板中创建自己的共享型 mysql 实例，然后在*pom.xml*里添加下 jdbc 驱动

```xml
<dependency>
	<groupId>mysql</groupId>
	<artifactId>mysql-connector-java</artifactId>
	<version>5.1.20</version>
</dependency>
```

然后，在咱们刚刚创建的 Serlvet 中，添加如下代码。

```java
String driver = "com.mysql.jdbc.Driver";
String username = System.getenv("ACCESSKEY");
String password = System.getenv("SECRETKEY");
String dbName = System.getenv("MYSQL_DB");
String host = System.getenv("MYSQL_HOST");
String port = System.getenv("MYSQL_PORT");
String dbUrl = "jdbc:mysql://"+host+":"+port + "/" +dbName;
try {
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl,username,password);
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery("show status");
	while(rs.next()){
		response.getWriter().println(rs.getString("Variable_name") + " : " +rs.getString("value"));
	}
} catch (ClassNotFoundException e) {
	e.printStackTrace();
} catch (SQLException e) {
	e.printStackTrace();
}
```

通过插件在上传到你的应用上，稍等一会就能看到如下的效果。

![mysql]({{ site.url }}/assets/show-mysql.png)

这里只是展示了最基本的使用方法，有些项目中会使用连接池，连接池只需要注意一项，将 idle 时间调整到 10 秒以下即可，无论是独享型还是共享型都是如此。


**Memcached**


Memcached 服务同样也要在你创建的应用中开启面板，初始化一下。容器使用的 memcache 有 auth 认证，需要使用支持 SASL 协议的客户端，推荐使用*spymemcached*客户端，首先在*pom.xml*文件中添加如下依赖。

```xml
<dependency>
	<groupId>net.spy</groupId>
	<artifactId>spymemcached</artifactId>
	<version>2.12.0</version>
</dependency>
```

同样，我们在刚刚我们新建的 servlet 中添加如下的代码。

```java
String username = System.getenv("ACCESSKEY");
String password = System.getenv("SECRETKEY");
String server = System.getenv("MEMCACHE_SERVERS");
AuthDescriptor ad = new AuthDescriptor(new String[] { "PLAIN" },
		new PlainCallbackHandler(username, password));
MemcachedClient mc = new MemcachedClient(
		new ConnectionFactoryBuilder().setProtocol(Protocol.BINARY).setAuthDescriptor(ad).build(),
		AddrUtil.getAddresses(server));
OperationFuture<Boolean> of = mc.set("key", 0, "sinacloud");
try {
	response.setCharacterEncoding("gbk");
	response.getWriter().println("设置结果是否成功："+ of.get());
	response.getWriter().println("获取结果："+mc.get("key"));
} catch (InterruptedException e) {
	e.printStackTrace();
} catch (ExecutionException e) {
	e.printStackTrace();
}
```

上传服务器后效果如下

![memcache]({{ site.url }}/assets/show-memcache.png)

这里只是简单的实现了 set 和 get 方法，其他的可以参看 [spymemcached](https://code.google.com/archive/p/spymemcached/)。


**Redis**


新浪云 Redis 服务，类似于 Memcache 服务，先在*pom.xml*里添加一个 redis 的客户端，如 jedis

```xml
<dependency>
	<groupId>redis.clients</groupId>
	<artifactId>jedis</artifactId>
	<version>2.0.0</version>
</dependency>
```

然后还是在刚刚建立的 Servlet 里添加如下代码。

```java
String redis_url = System.getenv("REDIS_URL");
try {
	URI redisUri = new URI(redis_url);
	JedisPool pool = new JedisPool(new JedisPoolConfig(),redisUri.getHost(),redisUri.getPort(),Protocol.DEFAULT_TIMEOUT,redisUri.getUserInfo().split(":",2)[1]);
	Jedis jedis = pool.getResource();
	response.getWriter().println(jedis.set("key".getBytes(), "sinacloud".getBytes()));
	response.getWriter().println(jedis.get("key"));
} catch (URISyntaxException e) {
	e.printStackTrace();
}
```

最后上传到新浪云上，可以看到效果。如下图。

![redis]({{ site.url }}/assets/show-redis.png)


**MongoDB**


首先还是在*pom.xml*中添加一下依赖。

```xml
<dependency>
	<groupId>org.mongodb</groupId>
	<artifactId>mongo-java-driver</artifactId>
	<version>3.2.2</version>
</dependency>
```
同时也需要在面板里初始化服务。然后可以根据自己的需要在 mongodb 实例中创建库或者是集合，我自己建立了一个叫"test"的库，然后建立了一个叫"users"的集合。

还是在那个 servlet 中插入如下的代码。

```java

MongoClientURI uri = new MongoClientURI("YOUR_MONGODB_URL");
MongoClient client = new MongoClient(uri);
MongoDatabase db = client.getDatabase("test");
MongoCollection<Document> users = db.getCollection("users");
Document user = new Document("key", "sinacloud");
users.insertOne(user);
response.getWriter().println(users.find(user).iterator().next().get("key"));

```
然后上传到新浪云，可以看到如下结果

![mongodb]({{ site.url }}/assets/show-mongodb.png)


**存储服务**


这里还是在上面建立的那个 Servlet 演示操作。对于容器 Java，我们提供了一套 SDK 支持，相关存储的操作，SDK 已经放在了 maven 的中央仓库上，可以通过 maven 进行下载，在项目的*pom.xml*中添加如下依
赖。

```xml
<dependency>
	<groupId>com.sinacloud.java</groupId>
	<artifactId>java-sdk</artifactId>
	<version>1.2.1</version>
</dependency>
```
目前，SDK 里包含了 kvdb（已经在 1.2.2 版本中去除）、云存储、Storage，以后新的服务，会在不断的增加。


**Storage**


Storage 服务是新浪云开发的一套对象存储服务，首先也要在面板上开启服务，初始化，然后在 servlet 中添加如下的代码。

```java
StorageClient sc = new StorageClient();
sc.createBucket("testbucket");
sc.putObjectFile("testbucket", "test.txt", "test storage client upload text".getBytes(), null);
```

然后上传到新浪云上，然后访问一下 Servlet，之后可以在自己 Storage 面板里，可以看到文件。如下图

![storage]({{ site.url }}/assets/show-storage.png)


**云存储**

参见[云存储](http://open.sinastorage.com/)，有详细的 [API](http://www.sinacloud.com/doc/scs/api)。




**分布式 Session**

多实例的情况下，准备了两种解决方案，一种是粘滞会话，另一种是第三方 Session 存储。粘滞会话可以在创建应用的时候开启。下面演示一下使用第三方 Redis 服务存储 Session

为了方便演示，我先把我测试的容器实例扩展到多个，到了 3 个 JVM，如图所示。

![session]({{ site.url }}/assets/distribute-session-01.png)

然后我们创建一个 redis 服务，具体创建参见 [Redis 文档](https://www.sinacloud.com/doc/sae/services/redis.html)，然后进入"应用"->"环境变量面板"，点击添加环境变量，添加以下两个环境变量。添加如下的环境变量。

 * REDIS_URL="YOUR_REDIS_URL"
 * SESSION_MANAGER=REDIS

然后我们重启下我们的应用。

还是在我们上面创建的 Servlet 里演示

```java
HttpSession session = request.getSession();
session.setAttribute("key", "sinacloud");
response.getWriter().println(session.getAttribute("key"));
```

然后我们访问下我们的 Servlet，如下图。

![session]({{ site.url }}/assets/distribute-session-02.png)

最后我们在确认下是否将 Session 的数据存储到了 Redis，进入到 Redis 控制面板，点击管理，输入如下命令。

 * keys *

可以看到如下的效果。

![session]({{ site.url }}/assets/distribute-session-03.png)

可以看到，由 Tomcat 自主存的 Session 信息，都在我们的 Redis 里了，这样就可以实现多实例之间的 Session 共享了。如果使用过程中需要存储对象，要预先对对象进行序列化


**最后**


以上简单的介绍了一下，新浪云容器环境 Java 相关的问题，主要是在新浪云相关的服务上，如果以后有新的服务或者问题，我会继续更新相关的使用方法和文档。当然使用中如果遇到上面问题，可以提交[工单](https://www.sinacloud.com/ucenter/workorderadd.html) 求助。

具体相关的服务可以参看容器服务的[文档中心](http://www.sinacloud.com/doc/sae/docker/index.html)。
