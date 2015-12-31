---
layout: post
title:  "一周更新 #52"
date:   2015-12-31 16:36:03
---

**云容器**

- 新增了对Go语言的支持。 [文档](http://www.sinacloud.com/doc/sc2/go-getting-started.html)
- 新增共享存储服务。对于不想使用对象存储而希望直接在本地保存数据的开发者，目前可以使用共享存储来存储数据。共享存储可以挂载到容器中的任意路径下，写入该路径下的各种文件会在各个容器之间共享。

    ![volume]({{ site.url }}/assets/sc2-volume.png)

**云应用**

- PHP5.6环境在测试了一段时间后，已经稳定运行，目前已经正式对企业用户开放，企业用户在创建应用的时候可以选择 **PHP5.6** 环境了。
- 针对用户反馈的服务超配后禁用时间太长的问题，缩短超配额禁用时间从之前的 **5** 分钟为 **1** 分钟。
- 优化了云应用Python环境对Cron的支持。
  + 提升Cron的最长执行时间为 **30** 分钟。
  + 提升可以并发执行的Cron Worker数目为 **20** 。
- 针对部分用户反馈 [Storage](http://www.sinacloud.com/doc/sae/services/storage.html) 文档难懂的问题，添加了大量的使用示例，详细见： [文档](http://apidoc.sinaapp.com/class-sinacloud.sae.Storage.html) 。
