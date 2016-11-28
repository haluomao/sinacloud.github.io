---
layout: post
title:  "使用新浪云 Java 环境搭建一个简单的微信处理后台"
date:   2016-11-28 18:12:01
---

前一段时间，写了一篇在新浪云上搭建自己的网站的教程，通过简单构建了一个 maven 的项目，展示部署的整个流程，具体的操作可以参看[这里](../../../2016/09/21/docker-java-get-started.html)。

新浪云服务器除了可以搭建自己的网站以外，也非常的适合作为微信公众号回调地址来使用（熟悉微信公众号开发的朋友可能已经了解了，如果不太清楚请参看[微信公众平台](https://mp.weixin.qq.com/wiki)），微信公众号的开发需要一个公网可以访问的服务器，用于处理消息的 token 的验证，以及自身业务的定制开发。在这里，写了一些简单操作的例子，给大家参考。

**准备**

开发微信公众号首先要申请自己的公众号，或者获得相关需要开发的公众号的操作权限，如何申请，这里就不具体讲了，具体的流程大家可以参看微信公众号的申请流程，需要注意的是自己的 *AppID* 和自己的 *AppSecret* ，不要泄漏，还需要自己设置一个 *token* 令牌，这里还有一个消息的加密密钥 *EncodingAESKey* ，可以随机生成，用于消息的加密解密。如下图所示：

![weixin-config]({{ site.url }}/assets/wx-config.png)

这里 URL 填写在新浪云申请的服务器的地址，当然具体指向到那个 path 我们需要自己去写一个 servlet，这里我自己定义了一个 WX 的 servlet，令牌我自己定义了一个，消息加密密钥使用了系统随机生成的，为了便于开发，所以消息加密方式，使用了明文的方式，这样消息就可以直观的看到，在填写完这些配置之后，在提交之后，微信的服务器会发一个 get 请求到我们填写的 URL 地址，去验证下 token，所以这里我们就预先要将这个 servlet 写好，简单的验证一步 token（代码会在下面列出），当验证通过后，修改才会成功，点击启用后，微信的服务器才会将客户端的消息，发送到我们提供的服务器。这里有具体的 [接入指南](https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1421135319&token=&lang=zh_CN)。

我在我的项目中建立了一个叫 WX 的 servlet。添加了如下的代码。

```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	String sig =  request.getParameter("signature");
	String timestamp =  request.getParameter("timestamp");
	String nonce =  request.getParameter("nonce");
	String echostr =  request.getParameter("echostr");
	String token = "xxxx"; // 这里填写自己的 token
	List<String> list = new ArrayList<String>();
	list.add(nonce);
	list.add(token);
	list.add(timestamp);
	Collections.sort(list);
	String hash = getHash(list.get(0)+list.get(1)+list.get(2), "SHA-1");
	if(sig.equals(hash)){ // 验证下签名是否正确
		response.getWriter().println(echostr);
	}else{
		response.getWriter().println("");
	}
}

public  String getHash(String source, String hashType) {
	StringBuilder sb = new StringBuilder();
	MessageDigest md5;
	try {
		md5 = MessageDigest.getInstance(hashType);
		md5.update(source.getBytes());
		for (byte b : md5.digest()) {
			sb.append(String.format("%02x", b));
		}
		return sb.toString();
	} catch (NoSuchAlgorithmException e) {
		e.printStackTrace();
	}
	return null;
}
```

在验证完成后， 原样返回 echostr 字符串就行了。这样填写服务器配置之后就可以成功的保存配置了。注意需要点击启用微信才会将客户端的消息转发给自己的服务器。

以上这个环节条中通过之后，我们来处理下消息，根据消息的输入做一些简单的返回，比如输入 hello 返回特定的字符串，返回定义的字符串，输入 time，返回当前的时间。这里要注意，咱们服务器接受的请求是由微信的服务器 post 过来的，所以，我们的处理过程要写在 doPost 方法里。

```java
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	String sig =  request.getParameter("signature");
	System.out.println("sig : "+sig);
	String timestamp =  request.getParameter("timestamp");
	String nonce =  request.getParameter("nonce");
	String echostr =  request.getParameter("echostr");
	String token = "nero";
	String responseContent = defaultStr;
	List<String> list = new ArrayList<String>();
	list.add(nonce);
	list.add(token);
	list.add(timestamp);
	Collections.sort(list);
	String hash = getHash(list.get(0)+list.get(1)+list.get(2), "SHA-1").toLowerCase();
	if(sig.equals(hash)){
		if(request.getMethod().equals("POST")){
			Map<String,String> map = XMLParse.extract(convertStreamToString(request.getInputStream()));
			if(map.get("Content").equals("hello")){
				responseContent = "Hello,This message from SinaCloud";
			}
			if(map.get("Content").equals("time")){
				sf.setTimeZone(TimeZone.getTimeZone("Asia/Shanghai"));
				responseContent = sf.format(new Date());
			}
			responseMsg = formatResponseMsg(responseContent, map);
		}
		response.setCharacterEncoding("utf-8");
		response.getWriter().println(responseMsg);
	}else{
		response.getWriter().println("success");
	}
}

public String convertStreamToString(InputStream is) {
	BufferedReader reader = new BufferedReader(new InputStreamReader(is));
	StringBuilder sb = new StringBuilder();
	String line = null;
	try {
		while ((line = reader.readLine()) != null) {
			sb.append(line);
		}
	} catch (IOException e) {
		e.printStackTrace();
	} finally {
		try {
			is.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	return sb.toString();
}

public String formatResponseMsg(String content,Map map){
	String responseMsg = "<xml>"
			+ "<ToUserName><![CDATA[%1$s]]></ToUserName>"
			+ "<FromUserName><![CDATA[%2$s]]></FromUserName>"
			+ "<CreateTime>%3$s</CreateTime>"
			+ "<MsgType><![CDATA[%4$s]]></MsgType>"
			+ "<Content><![CDATA[%5$s]]></Content>"
			+ "<MsgId>%6$s</MsgId>"
			+ "</xml>";
	return String.format(responseMsg, map.get("FromUserName"),map.get("ToUserName"),map.get("CreateTime"),map.get("MsgType"),content,map.get("MsgId"));
}
```

以上的代码就是处理的大概的过程，处理的效果如下。

![wx-msg]({{ site.url }}/assets/wx-msg.jpg)

以上就是使用新浪云大概搭建一个微信处理的后端程序，简单的实现了一些文本信息的交互功能，以后有时间继续写点其他消息的交互过程。
