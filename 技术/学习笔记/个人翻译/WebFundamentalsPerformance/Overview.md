---
name: 谷歌开发者文档-性能篇-Overview
title: 谷歌开发者文档-性能篇-Overview
tags: ["技术","学习笔记", "个人翻译", "WebFundamentalsPerformance"]
categories: 学习笔记
info: "Why does speed matter?"
time: 2021/9/7
desc: '个人翻译, Why does speed matter?, Web'
keywords: ['Git', '个人翻译', '学习笔记', '个人翻译', 'Why does speed matter']
---

# 谷歌开发者文档-性能篇-Overview

该系列为谷歌开发者文档的一些翻译，对应章节目录链接可以[访问这里](https://developers.google.com/web/fundamentals?hl=zh-cn)

> 原文链接：https://web.dev/why-speed-matters/

## Why does speed matter?

作为一个网站开发者，如果你去通过自己的数据观察网站，就会发现一个现象：正有越来越多的用户通过移动设备来访问具体的内容和服务。而且比起以前，用户对于网站的要求正越来越苛刻。当用户权衡你的网站并进行体验评分时，用户并不会只是将你的网站与竞争对手比较，他们更倾向于将你与他们每天用的最好的服务来进行对比。

关于网站性能和成功的商业之间的联系，这篇文章总结了一些相关的研究。

### 性能是留住用户的关键

> 性能会直接影响到公司的底线。

在任何成功的互联网企业中，网站性能都扮演着至关重要的作用。一个高性能网站会比低性能的网站吸引和留住更多用户。

缤趣将用户感知到的时间减少了百分之 40，[而这让它在搜索引擎的流量和注册量增加了 15%](https://medium.com/pinterest-engineering/driving-user-growth-with-performance-improvements-cfc50dafadd7)。

COOK 将页面的平均加载时间节省了 850 毫秒，从而提升了 7% 的转化率，降低了 7% 的跳出率，并将每次的访问涉及的页面数量增加了 10%。

还有研究表明，页面性能的不佳会对业务产生负面的影响。例如，BBC 发现网站的访问时间每增加一秒，他们就会额外损失 10% 的用户。

### 性能关乎用户转化率

用户的留存率是提升用户转化率的重要指标。性能差的网站通常会对转化率有负面影响，相对的，一个速度快的网站可以相应的提高转化率。

对于 [Mobify](http://resources.mobify.com/2016-Q2-mobile-insights-benchmark-report.html) 来说，首页的加载速度每降低 100ms，基于会话的转化率就会提升 1.11%，从而让每年的年平均收入上升了接近 380,000 美元。此外，页面切换的时间每降低 100ms，基于会话的转化率就会提升 1.55%，从而让年平均收入上升了接近 530,000 美元。

当 AutoAnything 将页面加载时间减少一半时，他们的销售额增长了 12% 到 13%。

零售商 [Furniture Village](https://www.thinkwithgoogle.com/intl/en-gb/success-stories/uk-success-stories/furniture-village-and-greenlight-slash-page-load-times-boosting-user-experience/) 通过对他们的网站进行了审计，并计划解决了他们所发现的问题。这让页面的加载时间减少了 20% 的同时，也提高了 10% 的页面转化率。

### 性能关乎用户体验

在用户体验方面，速度显得非常重要。一份消费者研究报告显示，在移动端，人们对于网站加载速度的压力（要求）有点像看一部恐怖电影或者解决一个数学难题，而且比在零售店排队结账的时候压力更大。

当一个网站开始加载时，用户会需要等待一段时间来让网站的内容加载。直到加载完成的这段时间为止，没有用户体验可言。在快速的网络连接中这种体验的缺失是稍纵即逝的，但是在一个缓慢的连接中，用户会被迫等待。而随着页面资源的缓慢加载，用户可能会经历更多的问题。

性能是用户体验的最基础的一个方面，当一个网站发送了大量的代码时，浏览器就必须使用以兆字节为单位的用户数据才能下载代码。而移动设备一般会对 CPU 和内存进行限制，所以会经常被一小部分没有优化的代码卡住。而这部分代码所导致的迟钝性能往往会导致网站无响应。而正如我们对于用户行为的了解一样，用户只会忍受低性能的应用一段时间，然后就会放弃掉它们了。

### 性能关乎人



> 下一段：Poorly performing sites and applications can also pose real costs for the people who use them.