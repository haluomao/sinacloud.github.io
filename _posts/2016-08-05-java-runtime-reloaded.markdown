---
layout: post
title:  "Java 运行环境：重装上阵"
date:   2016-08-05 18:12:01
---

![reloaded]({{ site.url }}/assets/matrix-reloaded.png)

年初的时候我们推出了基于容器的 Java 运行环境，经过半年时间的不断改进和优化，容器运行环境已经非常的稳定，在易用性上也有了长足的进步，所以我们决定，从下周起：

- 容器 Java 运行环境将成为 Java 应用默认也是唯一可选的运行环境。
- 下线旧 Java 运行环境（关闭创建入口，已经创建应用的用户和企业用户可以继续使用）。

下面，就让我们看看容器 Java 环境都有哪些特性和功能：

**[原生环境](#)**

基于 Docker 容器，采用 Tomcat8 作为 Web 服务器，OpenJDK1.8 作为运行环境，应用不用修改一行代码即可直接部署到云端，100% 成功的部署率。

**[Eclipse 插件极速部署](https://www.sinacloud.com/doc/sae/docker/java-eclipse-plugin.html)**

对于容器 Java 应用，除了提供传统的 Git 部署和网页上传的方式以外，我们还提供了 Eclipse 插件，让您不用登录新浪云控制台就可以一键部署应用，加速您的应用的整个开发和调试流程。

**[内置对分布式 Session 的支持](https://www.sinacloud.com/doc/sae/docker/java-session-manager.html)**

容器 Java 环境已经内置了对分布式 HttpSession 的支持，只需要简单的几个配置，就可以让您的应用获得一个稳定、可靠、安全的分布式 Session 解决方案。

**[Web 终端](#)**

让您可以从网页中直接登录 JVM 运行的服务器，查看 JVM 的运行状态。

**[共享存储](#)**

应用可以通过挂载，将对应的共享存储卷映射进容器中，使应用获得本地文件读写和数据持久化功能。

更多功能、特性和服务使用文档请参见： [https://www.sinacloud.com/doc/sae/java.html](https://www.sinacloud.com/doc/sae/java.html)
