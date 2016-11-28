---
layout: post
title:  "如何在新浪云上部署一个 Hubot 机器人"
date:   2016-09-21 21:12:01
---

![hubot]({{ site.url }}/assets/hubot.png)

> **What is Hubot?** Hubot is your company's robot. Install him in your company to dramatically improve and reduce employee efficiency.

Hubot 是 GitHub 开源的一个聊天机器人，可以用来在公司的在线聊天室（Slack、Campfire、Bearychat 等）里接受指令并完成一些自动化的工作（比如运维中重启机器、查看机器信息等）。

下文我们以 Hubot + [Bearychat](https://bearychat.com/) 为例，一步一步说明一下如何在新浪云上部署一个 Hubot 机器人。

**创建一个新 bot**

首先，按照 Hubot 官方文档的说明，使用 yo 创建一个新的 Hubot 项目。

```sh
$ npm install -g hubot coffee-script yo generator-hubot
$ cd /path/to/hubot
$ yo hubot
```

yo 提示输入 Bot adapter 时，输入 **bearychat** ，yo 会自动安装完 Hubot 以及 Bearychat adapter 所有相关的依赖包。

**本地运行**

进入 Hubot 代码目录，执行以下命令进入一个本地调试的命令行。检查调试 Hubot 功能是否 OK。

```sh
$ cd /path/to/hubot
$ bin/hubot
```

**部署到线上**

进入新浪云的控制台，创建一个新的云应用，语言选择 **NodeJS**。

进入 Bearychat 的机器人管理页面，选择添加一个 **Hubot** 机器人，在 *Hubot URL* 框里填入应用的 URL 地址。复制 *Hubot Token* ，进入新浪云应用控制台的 **应用／环境变量** 页面，创建一个新的环境变量。变量名为 *HUBOT\_BEARYCHAT\_TOKENS* ，值为刚才复制过来的 Token 。

最后我们进入刚才创建好的 Hubot 目录中，执行以下命令将代码部署到线上。

```sh
$ git remote add origin https://git.sinacloud.com/应用名
$ git push -u origin master
```

完成，现在，我们可以在 Bearychat 里调戏一把我们新加的 Hubot 机器人了。

![hubot-remchan]({{ site.url }}/assets/hubot-remchan.jpg)

**给机器人添加新的命令**

给 Hubot 添加新的命令非常的简单，在 scripts 目录下建一个 .coffee 或者 .js 结尾的文件，按照 *scripts/example.coffee* 中的示例添加你自己需要的命令即可。

参考：

- [Hubot 官方文档](https://hubot.github.com/docs/)
- [https://github.com/bearyinnovative/hubot-bearychat](https://github.com/bearyinnovative/hubot-bearychat)
