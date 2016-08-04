---
layout: post
title:  "如何在新浪云上部署一个 socket.io 应用"
date:   2016-08-04 14:12:01
---

![socket.io]({{ site.url }}/assets/socket_io_logo.png)

> Socket.IO aims to make realtime apps possible in every browser and mobile device, blurring the differences between the different transport mechanisms. It's care-free realtime 100% in JavaScript.

socket.io 是一个为实时应用提供跨平台实时通信的库。socket.io 旨在使实时应用在每个浏览器和移动设备上成为可能，模糊不同的传输机制之间的差异。socket.io 在新浪云也有着广泛的使用，比如容器应用中的 Web 终端、Redis 服务的管理页面都是基于 socket.io 来实现的。

下面我们以 socket.io 官方的 [聊天室示例](http://socket.io/demos/chat/>) 为例，详细说明一下一个 socket.io 应用在新浪云上的部署过程。

**如何部署**

首先，在新浪云『SAE 控制台』中选择『创建新应用』，运行环境选择 **容器** ，实例数目选择 **1** （注意，这里容器的实例数目必须为 **1** ，多实例需要额外配置，下文会有详细说明）。

下载 [sinacloud/nodejs-getting-started](https://github.com/sinacloud/nodejs-getting-started) 这里的代码，切换到 socket.io 分支，该分支下为 socket.io 聊天室代码的一个 clone。

添加一个名叫 sinacloud 的远程 Git 仓库，仓库的地址可以在『应用 / 代码管理』页面看到，并将本地的 socket.io 分支的代码推送到远程的 master 分支。

```sh
$ git clone https://github.com/sinacloud/nodejs-getting-started.git
$ cd nodejs-getting-started
$ git checkout socket.io
$ git remote add sinacloud https://git.sinacloud.com/<应用名>
$ git push sinacloud socket.io:master
```

完成，打开浏览器，输入应用的 URL，就可以访问刚才部署的聊天室应用了。

**多实例部署**

如果你的应用的访问量比较大，单容器实例已经满足不了需求需要多实例部署时，你还需要一些额外的配置。

首先，您需要开启粘滞会话（Sticky Session），保证同一个会话的请求被转发给固定的后端。

> This is due to certain transports like XHR Polling or JSONP Polling relying on firing several requests during the lifetime of the “socket”.

然后，创建一个 Redis ，并在『应用／环境变量』中将 Redis 的链接字符串加入到应用的环境变量中，变量名为 **REDIS_URL** 。

修改代码，添加一个 [socket.io-redis](https://github.com/automattic/socket.io-redis>) 的 adapter 用来在实例和实例之间通信。

package.json

```json
"dependencies": {
    "express": "3.4.8",
    "socket.io": "^1.3.7",
    "socket.io-redis": "git://github.com/socketio/socket.io-redis#708de4cb7e42107084f51dd37f3060d7899b3fdd"
}
```

注意，这里使用的 socket.io-redis 是 github 上的 dev master 版本，npm 源里的版本不支持连接带认证的 Redis。

```js
var redis = require('socket.io-redis');
// io 是创建的 socket.io 实例。
// REDIS_URL 为创建的 Redis 实例的链接字符串，可以在 Redis 实例的详情页面找到。
io.adapter(redis(REDIS_URL));
```

最后重新部署一下应用，现在你可以扩展（scale up）你的应用到任意个实例了。

在 Redis 的管理页面里执行一下 ``monitor`` 命令，可以看到 socket.io-redis 用 Redis 的 PubSub 来实现实例和实例间的通信。

```sh
redis:router> monitor
OK
1470280172.479693 [0 10.67.15.63:27857] "AUTH" "MfMfJdV2mat34FtaKnfi6IUeJt8aM7TZRgwnFpipLUTe6LnnryzAJkkOdIdetVdZ"
1470280172.479911 [0 10.67.15.63:27857] "INFO"
1470280186.825333 [0 10.13.144.213:47768] "AUTH" "MfMfJdV2mat34FtaKnfi6IUeJt8aM7TZRgwnFpipLUTe6LnnryzAJkkOdIdetVdZ"
1470280186.827128 [0 10.13.144.213:47768] "PING"
1470280193.949041 [0 10.67.21.62:51848] "subscribe" "socket.io#/#/#TJn0nk17WcnEB892AAAD#"
1470280196.224730 [0 10.67.21.62:51849] "publish" "socket.io#/#" "\x93\xa6kKgr7Z\x83\xa4type\x02\xa4data\x92\xabuser joined\x82\xa8user
name\xa2hi\xa8numUsers\x01\xa3nsp\xa1/\x83\xa6except\x91\xb6/#TJn0nk17WcnEB892AAAD\xa5rooms\xc4\xa5flags\x81\xa9broadcast\xc3"
```

完整代码：[https://github.com/sinacloud/nodejs-getting-started/tree/socket.io](https://github.com/sinacloud/nodejs-getting-started/tree/socket.io)

参考：

- [http://socket.io/docs/using-multiple-nodes/](http://socket.io/docs/using-multiple-nodes/)
- [使用Node.js+Socket.IO搭建WebSocket实时应用](http://www.plhwin.com/2014/05/28/nodejs-socketio/)
