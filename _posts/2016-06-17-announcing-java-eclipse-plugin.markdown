---
layout: post
title:  "容器 Java 应用支持使用 Eclipse 插件一键部署"
date:   2016-06-17 18:12:01
---

![eclipse-reloaded]({{ site.url }}/assets/matrix-reloaded.png)

详细请参见：[官方文档](https://www.sinacloud.com/doc/sae/docker/java-eclipse-plugin.html) 。

最近，通过观察，发现容器云部署java应用的时候，会花费大量的时间在下载相应的依赖上（原先部署java应用，使用的是maven，通过git提交线上之后，编译后发布），尤其是一些多重框架组合使用的应用，经常在编译下载依赖的过程中超时中断，往往需要二次甚至三次提交才能完成整个的依赖下载过程，体验比较差。

解决思路，将编译的过程放在本地，只将编译好的war包直接发布到容器，生成镜像，实现开发与发布直接对接，其实以上的过程也可以自行手动完成，但是考虑体验的问题，还是通过插件一键发布部署，体验更加的友好。

经过的一段时间的开发和测试，第一版容器部署插件，上线了（老版的runtime的功能继续支持，增加了容器一键部署功能）。具体操作方式可以参看[官方文档](https://www.sinacloud.com/doc/sae/docker/java-eclipse-plugin.html) 。

这里提供一个简单的demo给大家参考下：

首先，我们安装下eclipse的插件（具体安装方式文档中有详述），并在Sinacloud上创建一个自己的容器应用，参看容器应用的[相关文档](http://www.sinacloud.com/doc/sae/docker/index.html)。

然后，我们创建一个自己的web应用（这里我创建了一个test的web应用）。

![create-webapp]({{ site.url }}/assets/eclipse-doc-create.png)

创建一个index.jsp的页面，大致如下。

![create-page]({{ site.url }}/assets/eclipse-create-page.png)

最后，在test项目上右键，选择Sinacloud Web Services菜单的第一个选项Deploy，然后弹出如下对话框

![deploy-app]({{ site.url }}/assets/eclipse-doc-deploy.png)

稍等片刻，然后在观察自己应用的页面，就可以看到效果了

![deploy-success]({{ site.url }}/assets/eclipse-doc-deploy-success.png)


注：这里环境默认是jdk1.8+tomcat8。

