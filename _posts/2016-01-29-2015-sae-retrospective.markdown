---
layout: post
title:  "云应用平台（SAE）2015年更新回顾"
date:   2016-01-29 18:12:01
---

![tagcloud]({{ site.url }}/assets/2015-sae-keyword.png)

在过去的2015年里，我们的云应用平台上线了非常多的产品和服务，感谢我们平台上的广大开发者们在这一年里给我们提出的各种反馈和建议，帮助我们把产品和服务做得更好更稳定。

下面就让我们简要的回顾一下这一年里我们主要都推出了哪些新的产品和服务。

**[独享MySQL数据库（RDS）](http://www.sinacloud.com/doc/sae/php/rds.html)**

独享MySQL是新浪云提供的关系型数据库（RDS）服务，您仅需数十秒钟即可获得一个完整的MySQL服务，并且包括主从、高可用、自动备份、恢复、监控等各种功能。独享MySQL服务会为您启动独立的MySQL实例，分配给您独立使用，您可以根据需要创建多个用户以及多个数据库。相对于共享MySQL服务来说，没有其各种限制并且性能更高。

**[容器云](http://www.sinacloud.com/doc/sc2/index.html)**

- 基于Docker容器技术构建，支持部署各种语言的应用，目前支持NodeJS、Go、Java、Python。

**[Git代码部署](http://www.sinacloud.com/doc/sae/tutorial/code-deploy.html#shi-yong-git-ke-hu-duan)**

- 现在你可以使用最流行的代码版本管理工具来部署你的应用代码了。
- Git代码部署去除了SVN部署中版本目录的概念，让您更自然的组织代码接口、更加方便的开发测试您的应用。

**新的PHP-5.6运行环境**

- 最新的PHP5版本，让你可以使用各种最新的PHP特性。

**[Jetty9新运行环境](/2015/12/02/java-runtime-updates.html)**

- 升级Jetty至9、OpenJDK至7。
- 去除了版本，修改上下文为 ``/`` ，对各种Java框架提供了更好的支持。

**Python运行环境升级**

- 升级了Python版本至2.7.9。

**CC防火墙**

- 进一步提升了HTTP服务的稳定性，帮助云平台上的应用抵抗CC攻击。

**[应用防火墙](/2015/12/29/upgrade-afw.html)**

- 新增了Header特征过滤功能。
- 接入应用防火墙至云应用全平台，现在Java、Python以及容器云平台的应用都可以直接使用应用防火墙功能了。

**[实时日志](http://www.sinacloud.com/doc/api.html#shi-shi-ri-zhi)**

- 通过实时日志接口您可以实时获取云应用平台上应用的各种日志，甚至在云端直接对日志进行处理后再返回，更加方便的监控您在云端的应用。

**[VPN隧道服务](http://www.sinacloud.com/doc/sae/python/cloudbridge.html)**

- 通过VPN隧道服务直接拨入新浪云的网络环境，在自己的数据中心或者电脑上直接访问云端提供的各种服务。目前支持OpenVPN协议。

**[独立域名自定义SSL证书](http://www.sinacloud.com/doc/sae/services/ssl.html)**

- 让使用独立域名访问的应用可以开启https访问，让应用访问更加安全。

**[MySQL数据库恢复](http://www.sinacloud.com/doc/sae/services/mysql.html#bei-fen-hui-fu)**

- 支持在MySQL的管理页面中直接恢复您的数据库到14天内的任意时间点。

**计费**

- 提供了 ``消费统计`` ``7天消费详情``  等各种报表，让您可以更加清楚明了您的应用在云应用平台上的消费情况。

**[应用体检](http://www.sinacloud.com/doc/sae/services/logscan.html)**

- 优化了应用体检产品，添加了更多安全检查项。

**Storage服务优化**

- 优化了PHP SDK，更好的接口API。 [详情](http://apidoc.sinaapp.com/class-sinacloud.sae.Storage.html)
- 提供了 [Tempurl](http://apidoc.sinaapp.com/source-class-sinacloud.sae.Storage.html#813-829) 功能，让你可以更加方便的控制Storage中的Object的访问权限。

最后，在新的一年里，我们也将继续努力为你提供更多更好的服务和产品。
