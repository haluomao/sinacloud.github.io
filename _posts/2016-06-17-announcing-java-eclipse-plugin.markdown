---
layout: post
title:  "容器 Java 应用支持使用 Eclipse 插件一键部署"
date:   2016-06-17 18:12:01
---

最近，不少用户通过工单反馈容器运行环境部署 Java 应用的方法比较麻烦（使用 Maven，通过 Git 提交，线上编译发布），对于一些依赖比较多，尤其是一些多重框架组合使用的应用，整个部署过程非常的长，希望能够提供直接通过 War 包部署的功能。

经过的一段时间的开发和测试，今天我们正式对外发布了 **新浪云 Eclipse 插件** ，让你可以在 Eclipse 中一键将项目打成 War 包并部署到新浪云线上。 [官方文档](https://www.sinacloud.com/doc/sae/docker/java-eclipse-plugin.html)

这里提供一个简单的示例给大家参考下：

首先，我们下载并安装下 [新浪云 Eclipse 插件](http://www-docs.stor.sinaapp.com/sinacloud-eclipse-plugin.zip) ，并在新浪云上创建一个自己的 [容器](http://www.sinacloud.com/doc/sae/docker/index.html) 应用。

打开 Eclipse ，创建一个新的 Web 应用（这里我创建了一个名为 test 的 Web 应用）。

![create-webapp]({{ site.url }}/assets/eclipse-doc-create.png)

创建一个 index.jsp 的页面，大致如下。

![create-page]({{ site.url }}/assets/eclipse-create-page.png)

最后，在 test 项目上右键，选择 Sinacloud Web Services 菜单的第一个选项 Deploy，然后弹出如下对话框：

![deploy-app]({{ site.url }}/assets/eclipse-doc-delpoy.png)

输入你的安全邮箱和密码，点击 OK 部署，稍等片刻，即可再浏览器中访问刚才部署的应用了。

注：这里环境默认是 jdk1.8+tomcat8。
