---
layout: post
title:  "Counter 服务下线通知"
date:   2016-05-09 11:12:01
---

由于产品的升级调整，我们将从即刻起下线新浪云的 Counter 服务。

如果您的应用有使用 Counter 服务来做计数器的需求，可以使用我们的 [Redis](http://www.sinacloud.com/doc/sae/services/redis.html) 服务来替代，具体请参考： [Redis 使用案例（计数器 etc）]({{ site.url }}/2016/05/04/2-examples-redis.html) 。

现有 Counter 服务用户可以继续使用，下线不会对您的使用产生影响，但是我们还是强烈建议您迁移至我们的 Redis 服务。迁移方法如下：

1. 参照 [文档](http://www.sinacloud.com/doc/sae/services/redis.html) 的说明创建一个新的 Redis 实例。
2. 下载 [counter.class.php]({{site.url}}/assets/counter.class.php_) 这个类文件。
3. 替换原应用代码里使用 ``SaeCounter`` 类的地方为 *counter.class.php* 里的 ``Counter`` 类，``Counter`` 类的初始化参数为 Redis 实例的 URL，详细见类文件中的文档说明。
4. 调用 ``SaeCounter.getall()`` 方法 dump 出原 Counter 服务的数据再灌入 Redis 。完成。
