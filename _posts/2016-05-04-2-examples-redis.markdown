---
layout: post
title:  "Redis 使用案例（计数器 etc）"
date:   2016-05-04 11:12:01
---

![redis-logo]({{ site.url }}/assets/redis.png)

新浪云目前正式支持了 Redis 服务，用户可以简单的初始化一个 Redis，直接在应用里使用。无疑 Redis 功能是十分强大的，下面就来举两个简单的例子来描述一下 Redis 的一些应用场景。

**作为计数器**

自从有了 Redis 服务，就可以不需要原来提供的 Counter 服务了，Redis 非常适合作为计数器使用，而且也非常方便，只需要很少的几行代码：

```php
<?php

$redis = new Redis();
$redis->connect('host', port);
$redis->auth('password');

if (isset($_REQUEST['id'])) {
    echo '当前页面访问人数' . $redis->hIncrBy('PV_SET', $_REQUEST['id'], 1);
} else {
    $pvs = $redis->hGetAll('PV_SET');
    foreach($pvs as $id => $count) {
        echo "页面" . $id . "被访问" . $count . "次<br>";
    }
}
```

这是一个简单的统计页面，当请求参数中 id 不为空时，给对应 id 的页面访问加 1，如果 id 为空时，把所有页面的访问次数都打印出来。
所以，当不停访问某个 id 的文章时，就会出现 `当前页面访问人数 1,2,3,4` 不停的递增。
当不加 id 时，就会打印出所有页面的访问次数：

    页面 1 被访问 4 次
    页面 2 被访问 3 次
    页面 3 被访问 2 次

咦，这个貌似和 Counter 的用法没啥区别哎。其实还是有区别的，至少不用再一个一个去新建 Counter 了。

**取最新 N 个数据**

有的时候，我们可能只需要显示最新的一部分数据，比如最新的 100 条评论，最新的 10 条新闻，如果每次都去读数据库，那效率就比较低了，可是这样的数据存 Memcache 呢，也不是特别好用。
这时候，Redis 的强大就体现出来啦，来来，还是看代码，来实现一个简单的获取最新评论的功能。

```php
<?php

$redis = new Redis();
$redis->connect('host', port);
$redis->auth('password');

if (isset($_REQUEST['comment'])) {
    // 有新评论，添加到列表中
    $redis->lPush('latest.comment', $_REQUEST['comment']);
    // 只保留最新的 10 条，其他都丢掉
    $redis->lTrim('latest.comment', 0, 9);
    // 存入数据库
    //...
} else {
    // 取出最新的 10 条评论
    $comments = $redis->lRange('latest.comment', 0, 9);
    foreach($comments as $comment) {
        echo $comment . "<br>";
    }
}
```

最后的结果：

    three
    two
    one
    5
    4
    3
    2

这里利用了 Redis 的一个 List 功能，将所有评论从左边一个一个放到一个列表里，并利用提供的 LTrim 功能，将右边多余的给删除掉。
在取的时候，只需要从左边取对应的条数，就剩下了所有最新的数据了。是不是很简单呢？相对于直接从数据库中取 LIMIT N，速度也是会快上很多。

**其他场景**

除了上面的两个例子，Redis 还可以用在更多的地方，比如作为消息队列，实现生产 / 消费者模型；作为数据持久化的缓冲，解决数据库的写入瓶颈问题等等。
在新浪云内部，也是有非常多的系统使用 Redis 作为缓存，消息队列等用途，依托于 Redis 的超高性能，越来越多的系统开始使用 Redis 来解决系统中遇到的性能瓶颈。
