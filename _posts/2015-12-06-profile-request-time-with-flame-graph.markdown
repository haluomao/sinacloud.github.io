---
layout: post
title:  "使用火焰图来分析展示top响应时长的请求"
date:   2015-12-06 20:12:01
---

对线上应用进行性能分析的时候，我们首先得知道请求时间大部分都消耗在了哪些地方，之前在SAE上，我们提供了一个top响应时长分析的功能，它的输出类似于下面这样：

```
PATH               响应累积时长（降序排列）
================== =======================
/job/p=4.html      1509
/job/p=s00013.html 1450
...
```

但是从线上的使用来看，这个功能在很多时候作用有限，原因主要是：

- 部分PHP的框架的PATH只有一个 `/index.php` ，然后通过query_string来做route。
- 有些框架的PATH里也会传递参数，比如 `/user/100` ，这一类PATH的请求需要聚合。

比如上面的示例输出中，``/job/*`` 的请求需要聚合，单独一个一个的累积得到的结果就是上面这样，没有多大的意义。我们需要有一个方法能够聚合同类请求的响应时长，类似于下面这样：

```
/job               2959
    /p=4.html      1509
    /p=s00013.html 1450
```

有一个展示方式可以非常好的展示上面的分析结果，就是性能分析里常用的 [火焰图](https://github.com/brendangregg/FlameGraph) 。

下面我们尝试使用来火焰图来可视化时长分析的结果。

假设一条日志是这样的：

```
GET /path/to/request?args1=value1&args2=value2 0.096
```

我们将这个请求按照以下规则转换成类似于火焰图中的调用栈的形式：

1. 栈底为请求的Method。
2. 将请求的path用 ``/`` 分隔后依次压入栈中。
3. 如果有query_string的话，将query_string用 ``&`` 分隔后依次压入栈中。
4. 将请求时长转换成毫秒作为调用栈出现的次数。

最终生成的调用栈的形式如下：

```
    96

args2=value2
args1=value1
?
/request
/to
/path
GET
```

从下往上join起来就是完整的url。

接下来，我们将日志一条一条转换后按照火焰图工具的输入要求输出给火焰图工具。下面是使用新浪云的日志接口对应用的最后10000次请求时长做分析的代码：

```python
import urlparse
import urllib2
import re
import collections

# https://github.com/sinacloud/sae-python-dev-guide/blob/master/examples/apibus/apibus_handler.py
from apibus_handler import SaeApibusAuthHandler

ACCESSKEY = '应用的AccessKey'
SECRETKEY = '应用的SecretKey'

counter = collections.Counter()

apibus_handler = SaeApibusAuthHandler(ACCESSKEY, SECRETKEY)
opener = urllib2.build_opener(apibus_handler)
# 第3、10、11个字段分别是请求的时长、method、url
for line in opener.open('http://g.sae.sina.com.cn/log/http/2015-12-06/2-access.log?tail,0,10000|fields,%20,3,10,11').readlines():
    fields = line.strip().split(' ')
    # Method放在栈底
    stack = [fields[1],]
    parsed_url = urlparse.urlparse(fields[2])
    # 将请求路径按照 `/` 分隔开
    stack.extend(re.findall('/[^/]*', parsed_url.path))
    if parsed_url.query:
        # 如果有query_string，将query_string按照&分开。
        stack.extend('?')
        stack.extend(parsed_url.query.split('&'))
    # 请求时长的单位为s，将其转换为ms，这样在flame graph里显示的一个sample就是1ms。
    counter[tuple(stack)] += int(float(fields[0])*1000)

for k, v in counter.items():
    print ';'.join(k), v
```

将上面代码的输出传给flamegraph.pl程序，生成最终的火焰图。

```sh
$ python request-time-flamegraph.py | flamegraph.pl > flamegraph.svg
```

下面是SAE上某个应用的最后10000次请求生成的火焰图，从这个图里我们可以很明显的看出哪些请求的整体时长比较多，比如： ``GET /index.php?name=user&handle=getUserStateNums&ajax=1`` 这些请求占了整个大约25%的请求时长（108,806,631,000ms）。

![request-time-flamegrap]({{ site.url }}/assets/request-time-flamegraph.svg)

得到了请求的时长分布分析后，我们接下来就可以对这些请求做进一步的的分析和优化了。
