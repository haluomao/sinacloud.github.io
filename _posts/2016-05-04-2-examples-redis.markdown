---
layout: post
title:  "两用Redis"
date:   2016-05-04 11:12:01
---

SAE目前正式支持了Redis服务，用户可以简单的初始化一个Redis，直接在Runtime里使用。无疑Redis功能是十分强大的，下面就来瞅瞅Redis最简单的一些应用场景。
![example]({{ site.url }}/assets/example.jpg)


**作为计数器**

没错，说的就是你，SAE的Counter服务，有了Redis，什么难用的Counter服务，统统不需要了，再也不想见到它了。

那么怎么实现？ talk is cheap, show me the code!

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

这是一个简单的统计页面，当请求参数中id不为空时，给对应id的页面访问加1，如果id为空时，把所有页面的访问次数都打印出来。
所以，当不停访问某个id的文章时，就会出现 `当前页面访问人数1,2,3,4` 不停的递增。
当不加id时，就会打印出所有页面的访问次数：

    页面1被访问4次
    页面2被访问3次
    页面3被访问2次

咦，这个貌似和Counter的用法没啥区别哎。其实还是有区别的，至少不用再一个一个去新建Counter了。另外，是的，我就是这么喜新厌旧。

**取最新N个数据**

有的时候，我们可能只需要显示最新的一部分数据，比如最新的100条评论，最新的10条新闻，如果每次都去读数据库，那效率就比较低了，可是这样的数据存Memcache呢，也不是特别好用。
这时候，Redis的强大就体现出来啦，来来，还是看代码，来实现一个简单的获取最新评论的功能。

   <?php

    $redis = new Redis();
    $redis->connect('host', port);
    $redis->auth('password');
    
    if (isset($_REQUEST['comment'])) {
        //有新评论，添加到列表中
        $redis->lPush('latest.comment', $_REQUEST['comment']);
        //只保留最新的10条，其他都丢掉
        $redis->lTrim('latest.comment', 0, 9);
        //存入数据库
        //...
    } else {
        //取出最新的10条评论
        $comments = $redis->lRange('latest.comment', 0, 9);
        foreach($comments as $comment) {
            echo $comment . "<br>";
        }
    } 

    最后的结果：
    three
    two
    one
    5
    4
    3
    2

这里利用了Redis的一个List功能，将所有评论从左边一个一个放到一个列表里，并利用提供的LTrim功能，将右边多余的给删除掉。
在取的时候，只需要从左边取对应的条数，就剩下了所有最新的数据了。是不是很简单呢？相比于用Memcache存，方便的不要不要的，相比于数据库的Limit N，也是要快好多倍，
这个Redis真是超级好用，嘿嘿。

**其他场景**

除了上面的两个例子，Redis还可以用在更多的地方，比如作为消息队列，实现生产/消费者模型;作为数据持久化的缓冲，解决数据库的写入瓶颈问题等等。
依托于Redis的超高性能，越来越多的系统开始使用Redis来解决系统中遇到的性能瓶颈。
