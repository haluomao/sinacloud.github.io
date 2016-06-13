---
layout: post
title:  "一个 SNI 导致的外网访问 502 问题的解决过程"
date:   2016-06-13 11:12:01
---

最近有开发者通过工单系统向我们反馈 HTTPS 外网访问返回 502，而他本地访问是好的。通常这种情况一般是对端限制了我们的出口 IP。

首先，我们在出口服务器上使用 curl 工具访问一下这个 URL，看下是否被对端限制了我们的访问。

```sh
$ curl -v 'https://aa.com/'
* About to connect() to aa.com port 443 (#0)
*   Trying 104.24.1.1... connected
* Connected to aa.com (104.24.1.1) port 443 (#0)
* Initializing NSS with certpath: sql:/etc/pki/nssdb
*   CAfile: /etc/pki/tls/certs/ca-bundle.crt
  CApath: none
* NSS error -12286
* Closing connection #0
* SSL connect error
curl: (35) SSL connect error
```

通过 curl 的结果来看，显示已经建立了 TCP 连接，在 SSL Handshake 的时候失败。并不是对端限制了我们的出口 IP。

在新浪云上外网 HTTP 访问是通过我们的一个叫做 FetchURL 的服务来实现的。看下 FetchuURL 的日志，同样也是 SSL Handshake 时发生了问题，同时我们可以更清晰的看到是在 ``get server hello`` 的时候出错的。

```
SSL_do_handshake() failed (SSL: error:14077438:SSL routines:SSL23_GET_SERVER_HELLO:tlsv1 alert internal error)
```

``GET_SERVER_HELLO`` 是什么意思？我们来看下 SSL/TLS 握手。

![tls-handshake]({{ site.url }}/assets/tls-handshake.png)

TLS 握手时，Client 先发出请求 ``ClientHello`` 把支持的 TLS 版本、加密算法等发送到 Server。Server 确认应答 ``ServerHello`` 确认要使用的 TLS 版本以及加密算法，如果 Client 没有匹配的 TLS 版本和加密算法，Server 就关闭加密通信。了解了 TLS 握手协议后再看这个错误 ``SSL23_GET_SERVER_HELLO:tlsv1 alert internal error`` 就好解释了。

为了验证是不是 Client 不支持服务端的 TLS 版本和加密协议，我们使用 curl 指定一个比较强的加密协议： ``TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256`` 。

```
$ curl --ciphers ECDHE_ECDSA_AES_128_SHA -v 'https://aa.com'
* About to connect() to aa.com port 443 (#0)
*   Trying 104.24.113.140... connected
* Connected to aa.com (104.24.113.140) port 443 (#0)
* Initializing NSS with certpath: sql:/etc/pki/nssdb
*   CAfile: /etc/pki/tls/certs/ca-bundle.crt
  CApath: none
* SSL connection using TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA
* Server certificate:
*   subject: CN=sni161691.aaa.com,OU=PositiveSSL Multi-Domain,OU=Domain Control Validated
*   start date: May 24 00:00:00 2016 GMT
*   expire date: Nov 27 23:59:59 2016 GMT
*   common name: sni161691.aa.com
*   issuer: CN=COMODO ECC Domain Validation Secure Server CA 2,O=COMODO CA Limited,L=Salford,ST=Greater Manchester,C=GB
> GET / HTTP/1.1
> User-Agent: curl/7.19.7 (x86_64-redhat-linux-gnu) libcurl/7.19.7 NSS/3.19.1 Basic ECC zlib/1.2.3 libidn/1.18 libssh2/1.4.2
> Host: aa.com
> Accept: */*
```

成功！

通过修改并重新编译 FetchuURL 添加 TLS 版本和椭圆曲线公共密钥 (ECC) 加密算法。部署到测试环境后，抓该 URL 却依然返回 502。看了下错误日志还报 ``SSL_do_handshake() failed `` 。结合错误日志我们再理一下 FetchuURL 的逻辑，FetchuURL 是解析了域名后直接访问 IP:PORT。dig 了一下这个域名，解析后的 IP 也是正确的。在我本机通过 IP:PORT curl 的时候，发现有这么个警告 ``using IP address, SNI is being disabled by the OS`` 。看了下该网站是部署在了一个云计算平台上，可能用到了 SNI 支持多域名虚拟主机的 SSL/TLS 认证。因为我们就是这么搞的，在 ClientHello 阶段把 Host 带到 Server，Server 再加载对应 Host 的证书在 ServerHello 阶段把证书和公钥等信息发给 Client。

最后通过修改 FetchuURL 在 ClientHello 同时发送 Host，编译后部署到测试环境，这一次成功了。
