---
layout: post
title:  "一周更新 #49"
date:   2015-12-02 11:12:01
---

- 跨应用授权

    很多开发者有跨应用访问其它应用的服务的需求，本周我们提供了Memcache、KVDB两个服务的跨应用访问支持。

    现在开发者可以在 ``应用/应用设置/跨应用授权`` 页面直接授权其它应用访问本应用的MySQL、Memcache、KVDB等服务。

    关于如何使用API跨应用访问Memcache、KVDB服务，可以参考：

    - [跨应用使用KVDB](http://apidoc.sinaapp.com/source-class-SaeKV.html#138-145)
    - [跨应用使用Memcache](http://www.sinacloud.com/doc/sae/php/memcache.html?#shi-yong-shi-li)

- 容器云

  + 增加了MySQL、Memcache、Cron服务的支持。 [文档](http://www.sinacloud.com/doc/sc2/index.html#fu-wu-shi-yong-zhi-nan)
  + 优化了容器云的UI部分。
  + 添加了自动部署选项。目前在应用的部署页面勾选了自动部署后，下次git push的时候，服务端会自动开始部署应用到线上环境。

- Java运行环境去除版本、上下文，升级OpenJDK，Jetty，对Java框架提供了更好的支持。 [详情](/2015/12/02/java-runtime-updates.html)
