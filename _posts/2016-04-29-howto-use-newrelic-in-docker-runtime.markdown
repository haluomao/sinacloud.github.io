---
layout: post
title:  "使用 NewRelic 监控容器应用的性能"
date:   2016-04-29 18:12:01
---

NewRelic 是一个服务端代码级的应用性能监控（APM）平台。能够对应用进行实时性能监控（如数据库访问性能监控、 API 接口调用性能监控、运行环境监控、错误追踪，性能问题追踪、关键事务监控等），及时发现应用性能问题并定位性能瓶颈，提供性能问题诊断、追踪及优化依据。

在新浪云的容器运行环境中使用 NewRelic 非常的简单，下面我们以一个 Python 应用为例，说明 NewRelic 的使用方法。

首先，我们需要在 NewRelic 注册并创建一个新的 APM 项目。

![newrelic-create]({{ site.url }}/assets/newrelic-create.png)

创建完成之后，选择 Python 语言。

![newrelic-python]({{ site.url }}/assets/newrelic-python.png)

进入应用的代码目录，将 *newrelic* 加入 *requirements.txt* 文件中，让服务端在构建容器镜像的时候安装 *newrelic* 模块。

在本地安装 *newrelic* 模块。

```sh
$ pip install newrelic
```

生成 NewRelic 的配置文件（中间一长串字符串是您创建的 APM 项目的 License Key）。


```sh
$ newrelic-admin generate-config 4fd5a06************************7a2356e2b newrelic.ini
```

登录新浪云，进入容器应用的 *环境变量* 管理面板，添加 NewRelic 服务相关的环境变量。

![environ]({{ site.url }}/assets/sae-add-environ.png)

修改 *Procfile* 中 *web* 的启动命令，使用 *newrelic-admin* 来启动进程。

```
web: newrelic-admin run-program 进程实际启动的命令
```

提交更改的代码并部署到新浪云，等几分钟，您就可以在 NewRelic 的面板里看到容器应用的性能监控图表了。

下面是我们的 [Python 示例应用](https://github.com/sinacloud/python-getting-started) 的监控图表。

![newrelic-dashboard]({{ site.url }}/assets/newrelic-dashboard.png)

NewRelic APM 提供 NodeJS、Java 等语言的支持，更多使用请参见其官方使用文档。

