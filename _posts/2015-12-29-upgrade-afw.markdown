---
layout: post
title:  "应用防火墙（afw）功能升级"
date:   2015-12-29 11:36:03
---

近期，我们对应用防火墙的功能做了一些优化：

- ‘频率拦截’、‘流量拦截’支持全平台

- 输出了所有规则的拦截统计
    在‘业务防火墙页面’的‘拦截日志’展示了所有规则最近几分钟的拦截统计。如：
    ![afw-count]({{ site.url }}/assets/afw-count.png)

- 拦截日志输出到了日志中心
    在‘日志中心’添加了防火墙的拦截日志，并且会显示被哪种策略被拦截的。如：因为特征值策略被拦截。
    ![afw-log]({{ site.url }}/assets/afw-log.png)

- 增加了‘特征值过滤’的拦截策略
    新加了一种针对http请求的uri和header的过滤规则。通过在防火墙页面设置kv键值对使用。
    例如：设置了“uri:\*.ini,\*.conf”，就会在访问*.ini和*.conf时返回609。

[参考文档](http://www.sinacloud.com/doc/sae/php/afw.html)
